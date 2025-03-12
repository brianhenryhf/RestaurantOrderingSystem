class UserRegistrationsController < Devise::RegistrationsController
  # part of bypass of devise issues with DisabledSessionError in api-only apps
  include RackSessionFix
  # devise actions will consider json not acceptable by default
  respond_to :json

  # currently, only Customer users are creatable via api. Owners will be an admin/dev task. Hook into devise innards
  # to create Customer instead of User superclass.
  def resource_class
    Customer
  end
end
