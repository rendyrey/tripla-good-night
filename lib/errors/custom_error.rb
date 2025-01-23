# frozen_string_literal: true

module Errors::CustomError
  class UserNotFound < StandardError
    def initialize(message = "User not found")
      super
    end
  end

  class SleepRecordActive < StandardError
    def initialize(message = "There's a sleep record active")
      super
    end
  end

  class SleepRecordNotFound < StandardError
    def initialize(message = "Sleep record not found")
      super
    end
  end
end
