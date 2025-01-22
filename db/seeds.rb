# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

SleepRecord.destroy_all
User.destroy_all

10.times do
  User.create(
    name: Faker::Name.name
  )
end

50.times do
  SleepRecord.create(
    user: User.all.sample,
    sleep_at: Faker::Time.between(from: DateTime.now - 10.hours, to: DateTime.now),
    wake_at: Faker::Time.between(from: DateTime.now - 10.hours, to: DateTime.now)
  )
end
