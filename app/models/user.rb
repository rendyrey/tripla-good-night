# frozen_string_literal: true

class User < ApplicationRecord
  has_many :sleep_records, dependent: :destroy

  has_and_belongs_to_many :followings, class_name: "User", join_table: "user_followings", foreign_key: :user_id, association_foreign_key: :followed_user_id, dependent: :destroy
  has_and_belongs_to_many :followers, class_name: "User", join_table: "user_followings", foreign_key: :followed_user_id, association_foreign_key: :user_id, dependent: :destroy

  validates :name, presence: true

  def active_sleep_record
    sleep_records.find_by(wake_at: nil)
  end
end
