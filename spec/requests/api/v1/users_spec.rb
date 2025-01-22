# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /api/v1/users/:user_id/follow/:followed_user_id" do
    let(:user) { create(:user) }
    let(:followed_user) { create(:user) }

    it "should follow user" do
      post "/api/v1/users/#{user.id}/follow/#{followed_user.id}"

      expect(response).to have_http_status(:created)
      expect(user.followings).to include(followed_user)
    end

    it "should return error if user id not found" do
      post "/api/v1/users/#{user.id + 5}/follow/#{followed_user.id}"

      expect(response).to have_http_status(:not_found)
    end

    it "should return errof if followed user id not found" do
      post "/api/v1/users/#{user.id}/follow/#{followed_user.id + 5}"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/v1/users/:user_id/unfollow/:followed_user_id" do
    let(:user) { create(:user) }
    let(:followed_user) { create(:user) }

    it "should unfollow user" do
      user.followings << followed_user
      delete "/api/v1/users/#{user.id}/unfollow/#{followed_user.id}"

      expect(response).to have_http_status(:ok)
      expect(user.followings).not_to include(followed_user)
    end

    it "should return error if user id not found" do
      delete "/api/v1/users/#{user.id + 5}/unfollow/#{followed_user.id}"

      expect(response).to have_http_status(:not_found)
    end

    it "should return errof if followed user id not found" do
      delete "/api/v1/users/#{user.id}/unfollow/#{followed_user.id + 5}"

      expect(response).to have_http_status(:not_found)
    end
  end
end
