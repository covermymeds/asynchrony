module Asynchrony
  module SpecificErrors
    ALL_ERROR_CODES = (300..999)

    def initialize
      @rescuable_errors = Array(ALL_ERROR_CODES)
    end

    def rescue(*error_codes)
      @rescuable_errors = Array(error_codes)
    end

    private

    def status
      @sync_response.status
    end

    def do_not_rescue!
      @do_not_rescue = true
    end

    def do_not_rescue?
      @doc_not_rescue
    end

    def rescue_this_error
      Array(@rescuable_errors).include?(status)
    end
  end
end
