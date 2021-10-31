module Api
  module V1
    class PasswordsController < DeviseTokenAuth::PasswordsController
      skip_forgery_protection
      include Api::Concerns::ActAsApiRequest
      skip_before_action :check_json_request, on: :edit
    end
  end
end
