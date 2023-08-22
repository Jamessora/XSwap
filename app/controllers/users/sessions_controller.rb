class Users::SessionsController < Devise::SessionsController
    respond_to :json
    
        
    def create
    Rails.logger.debug "Parameters: #{params.inspect}"
    user = find_user_by_email
    Rails.logger.debug "Email: #{params.dig(:user, :email)}"
    Rails.logger.debug "Password: #{params.dig(:user, :password)}"
    Rails.logger.debug "User found: #{user.inspect}"
    Rails.logger.debug "Is password valid? #{valid_password?(user)}"
    Rails.logger.debug "Is user confirmed? #{user.confirmed? if user}"

        if user.nil? || !valid_password?(user)
        render_invalid_email_or_password
        Rails.logger.info("Invalid email or password")
        elsif !user.confirmed?
        render_email_not_confirmed
        Rails.logger.info("User not confirmed")
        else
        render_successful_login
        Rails.logger.info("Login success")
        end


        
    end
  
  private
  
  def find_user_by_email
    User.find_by_email(params.dig(:user, :email))
  end
  
  def valid_password?(user)
    user.valid_password?(params.dig(:user, :password))
  end
  
  def render_invalid_email_or_password
    render json: { error: 'Invalid email or password.' }, status: :unauthorized
  end
  
  def render_email_not_confirmed
    render json: { error: 'Please confirm your email before logging in.' }, status: :unauthorized
  end
  
  def render_successful_login
    render json: {
      message: 'You are logged in.',
      user: current_user
    }, status: :ok
  end

    def respond_to_on_destroy
    end

    def log_out_success
        render json: {message: 'You have logged out successfully'}, 
        status: :ok
    end

    def log_out_failure
        render json: {message: 'You have logged out successfully'},
        status: :unauthorized
    end
end


