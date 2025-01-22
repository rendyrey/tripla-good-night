# frozen_string_literal: true

# load custom lib for custom error
require "errors/custom_error"

class ApplicationController < ActionController::API
  include UserConcern
  include CustomError
end
