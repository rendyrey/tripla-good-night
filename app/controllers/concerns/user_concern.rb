# frozen_string_literal: true

module UserConcern
  def find_user
    begin
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User with given user_id not found" }, status: :not_found
    end
  end
end
