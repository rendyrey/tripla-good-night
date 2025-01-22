# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :find_user, only: %i[follow unfollow]
  def follow

  end

  private
end
