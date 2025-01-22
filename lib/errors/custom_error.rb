# frozen_string_literal: true

module CustomError
  class UserNotFound < StandardError
    def initialize(message = "User not found")
      super
    end
  end
end
