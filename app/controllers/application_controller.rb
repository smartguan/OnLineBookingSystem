class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

    def verify_authenticity_token
      unless verified_request? || json_request?
        logger.warn "Can't verify CSRF token authenticity" if logger
        handle_unverified_request
      end
    end

    def json_request?
      request.format.json?
    end
end
