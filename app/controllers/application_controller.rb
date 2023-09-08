class ApplicationController < ActionController::API
    include ActionController::Helpers

  helper_method :current_user

  def current_user
 
    warden.authenticate(scope: :user)
  end
end
