class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
  
      if resource.errors.empty?
        set_flash_message!(:notice, :confirmed)
        redirect_to "https://xswap-fe.onrender.com/confirm-email?confirmation_token=#{params[:confirmation_token]}", allow_other_host: true
      else
        render :action => 'new'
      end
  end

  def api_confirm
      
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])
      
      if resource.errors.empty?
        render json: { success: true, message: 'Email confirmed' }
      else
        render json: { success: false, message: 'Invalid token' }, status: :unprocessable_entity
      end
  end
end
