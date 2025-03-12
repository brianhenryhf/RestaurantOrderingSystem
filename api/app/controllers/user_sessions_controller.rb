class UserSessionsController < Devise::SessionsController
  # part of bypass of devise issues with DisabledSessionError in api-only apps
  include RackSessionFix
  # devise actions will consider json not acceptable by default
  respond_to :json

  # another part of bypass of devise issues giving DisabledSessionError in api-only apps
  def auth_options
    super.merge({store: false})
  end
end
