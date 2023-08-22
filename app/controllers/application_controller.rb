class ApplicationController < ActionController::API
    include ActionController::Helpers

  helper_method :current_user

  def current_user
    # Assuming you're using Devise for authentication
    warden.authenticate(scope: :user)
  end
end
