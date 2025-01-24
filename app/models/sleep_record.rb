# frozen_string_literal: true

class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :sleep_at, presence: true
  before_save :update_duration

  scope :previous_week, -> { where(sleep_at: 1.week.ago.beginning_of_day..DateTime.now) }

  def update_duration
    if self.wake_at.present?
      self.duration = (self.wake_at - self.sleep_at).to_i
    end
  end
end
