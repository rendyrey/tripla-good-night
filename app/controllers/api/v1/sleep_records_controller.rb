# frozen_string_literal: true

class Api::V1::SleepRecordsController < ApplicationController
  before_action :find_user, only: %i[clock_in wake_up]
  rescue_from CustomError::SleepRecordActive, with: :handle_active_sleep_record
  rescue_from CustomError::SleepRecordNotFound, with: :handle_sleep_record_not_found

  def index
    sleep_records = SleepRecord.order(created_at: :asc)

    render json: sleep_records, status: :ok
  end

  def clock_in
    check_active_sleep # check active sleep, if there's an active sleep record, raise error (User can't have more than 1 active sleep record)
    @user.sleep_records.create(sleep_at: DateTime.now)
    clocked_in_times = @user.sleep_records.order(created_at: :asc)&.pluck(:sleep_at)

    # 1. Clock in operation, and return all clocked-in times, ordered by created_time
    render json: {
      user: @user.as_json(except: [:created_at, :updated_at]),
      clocked_in_times: clocked_in_times
    }, status: :created
  end

  def wake_up
    sleep_recod_updated = @user.active_sleep_record&.update(wake_at: DateTime.now)
    raise CustomError::SleepRecordNotFound if sleep_recod_updated.nil? # raise error if there's no active sleep record

    render json: { message: "Successfully clocked out/wake up" }, status: :ok
  end

  private
    def check_active_sleep
      sleep_record = @user.sleep_records.where(wake_at: nil).first
      raise CustomError::SleepRecordActive if sleep_record.present?
    end

    def handle_active_sleep_record
      render json: { error: "An active sleep record is exists, please clock out/wake up first" }, status: :unprocessable_entity
    end

    def handle_sleep_record_not_found
      render json: { error: "Active sleep record not found" }, status: :not_found
    end
end
