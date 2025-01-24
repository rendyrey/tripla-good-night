# frozen_string_literal: true

class AddDurationToSleepRecords < ActiveRecord::Migration[8.0]
  def change
    add_column :sleep_records, :duration, :integer, default: 0
  end
end
