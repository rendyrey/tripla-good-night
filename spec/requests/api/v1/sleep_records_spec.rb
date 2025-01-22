# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::SleepRecords", type: :request do
  describe "GET /api/v1/sleep-records" do
    let!(:sleep_record_1) { create(:sleep_record) }
    let!(:sleep_record_2) { create(:sleep_record) }
    let!(:sleep_record_3) { create(:sleep_record) }

    it "should return all sleep records ordered by created_at" do
      get "/api/v1/sleep-records"

      expect(response).to have_http_status(:ok)
      sleep_records = JSON.parse(response.body)
      expect(sleep_records).to match_array([sleep_record_1.as_json, sleep_record_2.as_json, sleep_record_3.as_json])
      expect(sleep_records.count).to eq(3)
      expect(sleep_records.first['id']).to eq(sleep_record_1.id)
      expect(sleep_records.last['id']).to eq(sleep_record_3.id)
    end
  end

  describe "POST /api/v1/sleep-records/clock-in/:user_id" do
    let(:user) { create(:user) }

    it "should creates a new sleep record" do
      post "/api/v1/sleep-records/clock-in/#{user.id}"

      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(user.sleep_records.count).to eq(1)
      expect(json_response['data']['user']['id']).to eq(user.id)
      expect(json_response['data']['clocked_in_times'].count).to eq(1)
    end

    it "should return error if user not found" do
      post "/api/v1/sleep-records/clock-in/#{user.id + 1}"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /api/v1/sleep-records/wake-up/:user_id" do
    let(:user) { create(:user) }
    let!(:sleep_record) { create(:sleep_record, user: user, wake_at: nil) }

    it "should update sleep record" do
      patch "/api/v1/sleep-records/wake-up/#{user.id}"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(user.sleep_records.count).to eq(1)
      expect(json_response['data']['user_id']).to eq(user.id)
      expect(json_response['data']['wake_at']).not_to be_nil
    end

    it "should return error if user not found" do
      patch "/api/v1/sleep-records/wake-up/#{user.id + 1}"

      expect(response).to have_http_status(:not_found)
    end

    it "should return error if there's no active sleep record" do
      sleep_record.update(wake_at: DateTime.now) # had been clocked out
      patch "/api/v1/sleep-records/wake-up/#{user.id}"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /api/v1/sleep-records/following-sleep-records/:user_id" do
    let(:user) { create(:user) }
    let(:followed_user) { create(:user) }
    let!(:sleep_record_1) { create(:sleep_record, user: user) }
    let!(:sleep_record_2) { create(:sleep_record, sleep_at: 4.day.ago, wake_at: DateTime.now, user: followed_user) }
    let!(:sleep_record_3) { create(:sleep_record, sleep_at: 2.day.ago, wake_at: DateTime.now, user: followed_user) }
    let!(:sleep_record_4) { create(:sleep_record, sleep_at: 3.days.ago, wake_at: DateTime.now, user: followed_user) }
    let!(:sleep_record_5) { create(:sleep_record, sleep_at: 1.day.ago, wake_at: DateTime.now, user: followed_user) }

    it "should return sleep records of followed users from previous week, ordered by duration ascending" do
      user.followings << followed_user
      get "/api/v1/sleep-records/following-sleep-records/#{user.id}"

      expect(response).to have_http_status(:ok)
      sleep_records = JSON.parse(response.body)
      expect(sleep_records.count).to eq(4)
      expect(sleep_records.first['id']).to eq(sleep_record_5.id) # smallest duration
      expect(sleep_records.last['id']).to eq(sleep_record_2.id) # biggest duration
    end

    it "should return error if user not found" do
      get "/api/v1/sleep-records/following-sleep-records/#{user.id + 9}"

      expect(response).to have_http_status(:not_found)
    end
  end
end
