# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:sleep_at) }
  end

  describe "scopes" do
    describe ".previous_week" do
      it "return sleep records for previous week" do
        sleep_record_1 = create(:sleep_record, sleep_at: 2.days.ago, wake_at: DateTime.now)
        sleep_record_2 = create(:sleep_record, sleep_at: 3.weeks.ago, wake_at: DateTime.now)
        sleep_record_3 = create(:sleep_record, sleep_at: 1.week.ago, wake_at: DateTime.now)
        sleep_record_4 = create(:sleep_record, sleep_at: 1.day.ago, wake_at: DateTime.now)

        # Rails.lo
        expect(SleepRecord.previous_week).to match_array([sleep_record_1, sleep_record_3, sleep_record_4])
      end
    end
  end

  describe "create sleep record" do
    it "should create sleep record" do
      expect { create(:sleep_record) }.to change { SleepRecord.count }.by(1)
    end

    it "should create sleep with nil wake_at time" do
      expect { create(:sleep_record, sleep_at: DateTime.now, wake_at: nil) }.to change { SleepRecord.count }.by(1)
    end

    it "should error create sleep record" do
      expect { create(:sleep_record, sleep_at: nil, wake_at: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
