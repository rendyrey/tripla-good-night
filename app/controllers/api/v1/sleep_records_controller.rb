# frozen_string_literal: true

class Api::V1::SleepRecordsController < ApplicationController
  before_action :find_user, only: %i[clock_in]

  def index
    sleep_records = SleepRecord.order(created_at: :asc)

    render json: sleep_records, status: :ok
  end

  def clock_in
    @user.sleep_records.create(sleep_at: DateTime.now)
    clocked_in_times = @user.sleep_records.order(created_at: :asc)&.pluck(:sleep_at)

    # 1. Clock in operation, and return all clocked-in times, ordered by created_time
    render json: {
      user: @user.as_json(except: [:created_at, :updated_at]),
      clocked_in_times: clocked_in_times
    }, status: :created
  end

  private

    def find_user
      begin
        @user = User.find(params[:user_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "User with given user_id not found" }, status: :not_found
      end
    end
end
