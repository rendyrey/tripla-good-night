# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:sleep_records).dependent(:destroy) }
    it { should have_and_belong_to_many(:followings).dependent(:destroy).class_name('User') }
    it { should have_and_belong_to_many(:followers).dependent(:destroy).class_name('User') }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "methods" do
    let(:user) { create(:user) }

    describe "#active_sleep_record" do
      it "return active sleep record" do
        sleep_record_1 = create(:sleep_record, sleep_at: DateTime.now, wake_at: nil, user: user)
        sleep_record_2 = create(:sleep_record, sleep_at: 1.hour.ago, wake_at: DateTime.now, user: user)
        expect(user.active_sleep_record).to eq(sleep_record_1)
      end
    end
  end

  describe "followings" do
    it "return following users" do
      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)
      user_1.followings << [user_2, user_3]

      expect(user_1.followings).to match_array([user_2, user_3])
    end

    it "return followers" do
      user_1 = create(:user)
      user_2 = create(:user)
      user_3 = create(:user)
      user_1.followers << [user_2, user_3]

      expect(user_1.followers).to match_array([user_2, user_3])
    end
  end

  describe "create user" do
    it "should create user" do
      expect { create(:user) }.to change { User.count }.by(1)
    end

    it "should error create user" do
      expect { create(:user, name: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
