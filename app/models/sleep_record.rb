# frozen_string_literal: true

class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :sleep_at, presence: true

  scope :previous_week, -> { where(sleep_at: 1.week.ago.beginning_of_day..DateTime.now) }

  def duration
    return 0 if wake_at.nil?

    (wake_at - sleep_at).to_i
  end
end
