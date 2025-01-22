# frozen_string_literal: true

FactoryBot.define do
  factory :sleep_record do
    association :user
    sleep_at { Faker::Time.between(from: DateTime.now - 10.hours, to: DateTime.now) }
    wake_at { Faker::Time.between(from: sleep_at, to: DateTime.now) }
  end
end
