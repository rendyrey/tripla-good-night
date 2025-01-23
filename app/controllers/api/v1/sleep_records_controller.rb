# frozen_string_literal: true

class Api::V1::SleepRecordsController < ApplicationController
  before_action :find_user, only: %i[clock_in wake_up following_sleep_records]
  rescue_from Errors::CustomError::SleepRecordActive, with: :handle_active_sleep_record
  rescue_from Errors::CustomError::SleepRecordNotFound, with: :handle_sleep_record_not_found

  def index
    page_param = params[:page]
    if page_param.blank?
      render json: { error: "page parameter is required" }, status: :unprocessable_entity
      return
    end

    per_page = params[:per_page] || 10
    sleep_records = SleepRecord.order(created_at: :asc).page(page_param).per(per_page)
    current_page = sleep_records.current_page
    total_pages = sleep_records.total_pages

    render json: {
      meta: {
        total_pages: sleep_records.total_pages,
        current_page: sleep_records.current_page,
        next_page: next_page_link(current_page, total_pages, per_page),
        prev_page: prev_page_link(current_page, per_page),
        total_count: sleep_records.total_count
      },
      data: sleep_records
    }, status: :ok
  end

  def clock_in
    check_active_sleep # check active sleep, if there's an active sleep record, raise error (User can't have more than 1 active sleep record)
    @user.sleep_records.create(sleep_at: DateTime.now)
    clocked_in_times = @user.sleep_records.order(created_at: :asc)&.pluck(:sleep_at)

    # 1. Clock in operation, and return all clocked-in times, ordered by created_time
    render json: {
      message: "Successfully clocked in",
      data: {
        user: @user.as_json(except: [:created_at, :updated_at]),
        clocked_in_times: clocked_in_times
      }
    }, status: :created
  end


  def wake_up
    active_sleep_record = nil
    ActiveRecord::Base.transaction do
      active_sleep_record = SleepRecord.lock.find_by(user_id: @user.id, wake_at: nil)
      sleep_record_updated = active_sleep_record&.update(wake_at: DateTime.now)
      raise Errors::CustomError::SleepRecordNotFound if sleep_record_updated.nil? # raise error if there's no active sleep record
    end

    render json: { message: "Successfully clocked out/wake up", data: active_sleep_record }, status: :ok
  end

  def following_sleep_records
    followed_user_ids = @user.followings.pluck(:followed_user_id)
    sleep_records = SleepRecord.where(user_id: followed_user_ids)
      .previous_week
      .sort_by(&:duration)

    sleep_records.map! do |sleep_record|
      sleep_record.as_json.merge(duration: sleep_record.duration)
    end

    render json: sleep_records, status: :ok
  end

  private
    def check_active_sleep
      sleep_record = @user.sleep_records.where(wake_at: nil).first
      raise Errors::CustomError::SleepRecordActive if sleep_record.present?
    end

    def handle_active_sleep_record
      render json: { error: "An active sleep record is exists, please clock out/wake up first" }, status: :unprocessable_entity
    end

    def handle_sleep_record_not_found
      render json: { error: "Active sleep record not found" }, status: :not_found
    end

    def next_page_link(current_page, total_pages, per_page)
      return nil if current_page >= total_pages

      url_for(controller: controller_name, action: action_name, page: current_page + 1, per_page: per_page)
    end

    def prev_page_link(current_page, per_page)
      return nil if current_page <= 1

      url_for(controller: controller_name, action: action_name, page: current_page - 1, per_page: per_page)
    end
end
