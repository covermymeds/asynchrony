module Asynchrony
  module SpecificErrors
    ALL_ERROR_CODES = (300..999)

    def initialize
      @rescuable_errors = Array(ALL_ERROR_CODES)
    end

    def rescue(*error_codes)
      @rescuable_errors = error_codes
    end

    private

    def status
      @sync_response.status
    end

    def rescue_this_error?
      @rescuable_errors.include?(status)
    end
  end
end
