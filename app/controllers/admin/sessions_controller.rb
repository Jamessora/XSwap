class Admin::SessionsController < Devise::SessionsController
    respond_to :json
    
        
    def create
      Rails.logger.debug "Parameters: #{params.inspect}"
      admin = find_admin_by_email
      Rails.logger.debug "Email: #{params.dig(:admin, :email)}"
      Rails.logger.debug "Password: #{params.dig(:admin, :password)}"
      Rails.logger.debug "Admin found: #{admin.inspect}"
      Rails.logger.debug "Is password valid? #{valid_password?(admin)}"
      Rails.logger.debug "Is admin confirmed? #{admin.confirmed? if admin}"

          
        if admin.nil? || !valid_password?(admin)
          render_invalid_email_or_password
          Rails.logger.info("Invalid email or password")
        elsif !admin.confirmed?
          render_email_not_confirmed
          Rails.logger.info("admin not confirmed")
        elsif admin.role != "admin" 
          render_role_restricted
          Rails.logger.info("Access restricted to admin role")
        else
          render_successful_login
          Rails.logger.info("Login success")
        end



        
    end

      
    def destroy
      sign_out current_admin
      render json: {message: 'You have logged out successfully.'},
      status: :ok
    end


    private
    
    def find_admin_by_email
      Admin.find_by(email: params[:admin][:email])
    end
    
    def valid_password?(admin)
      admin&.valid_password?(params.dig(:admin, :password))
    end
    
    def render_invalid_email_or_password
      render json: { error: 'Invalid email or password.' }, status: :unauthorized
    end
    
    def render_email_not_confirmed
      render json: { error: 'Please confirm your email before logging in.' }, status: :unauthorized
    end
    
    def render_role_restricted
      render json: { error: 'Access restricted to admin role.' }, status: :forbidden
    end
    
    def render_successful_login
      render json: {
        message: 'You are logged in.',
        admin: current_admin
      }, status: :ok
    end

  
   

      
end


