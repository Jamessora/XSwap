class Users::ConfirmationsController < Devise::ConfirmationsController

    def show
        self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    
        if resource.errors.empty?
          set_flash_message!(:notice, :confirmed)
          # Redirect to your React app's URL where you want the user to go after confirming their account.
          redirect_to 'https://xswap-fe.onrender.com/login'
        else
          render :action => 'new'
        end
      end


end
