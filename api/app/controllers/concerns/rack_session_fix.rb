# spoofs a session store when session is disabled (for api-only apps), else devise complains like
# `ActionDispatch::Request::Session::DisabledSessionError (Your application has sessions disabled. To write to the session you must first configure a session store):`
# https://github.com/waiting-for-dev/devise-jwt/issues/235
#
# REST api traditionally shouldn't use session, and JWT-based auth on client has no use for Rails session, so this
# should be harmless.
module RackSessionFix
  extend ActiveSupport::Concern

  class FakeRackSession < Hash
    def enabled?
      false
    end
  end

  included do
    before_action :set_fake_rack_session_for_devise

    private

    def set_fake_rack_session_for_devise
      puts 'setting fake session'
      request.env['rack.session'] ||= FakeRackSession.new
    end
  end
end