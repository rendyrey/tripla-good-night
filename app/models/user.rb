# frozen_string_literal: true

class User < ApplicationRecord
  has_many :sleep_records

  def active_sleep_record
    sleep_records.where(wake_at: nil).first
  end
end
