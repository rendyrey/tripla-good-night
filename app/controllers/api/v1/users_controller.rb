# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :find_user, only: %i[follow unfollow]
  def follow
    begin
      if @user.id == params[:followed_user_id].to_i
        render json: { error: "You cannot follow yourself" }, status: :unprocessable_entity
        return
      end

      new_following_user = User.find(params[:followed_user_id])
      @user.followings << new_following_user

      render json: { message: "Successfully followed" }, status: :created
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User with given followed_user_id not found" }, status: :not_found
    rescue ActiveRecord::RecordNotUnique
      render json: { error: "User already followed the user with id: #{params[:followed_user_id]}" }, status: :unprocessable_entity
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def unfollow
    begin
      following_user = User.find(params[:followed_user_id])
      @user.followings.delete(following_user)

      render json: { message: "Successfully unfollowed" }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User with given followed_user_id: #{params[:followed_user_id]} not found" }, status: :not_found
    end
  end
end
