class Admin::ConfirmationsController < Devise::ConfirmationsController

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    
    if resource.errors.empty?
      
      # Redirect to React frontend with success status
      redirect_to "https://xswap-fe.onrender.com/confirmation-success?status=success",  allow_other_host: true
    else
      # Redirect to React frontend with failure status
      redirect_to "https://xswap-fe.onrender.com/confirmation-success?status=failure",  allow_other_host: true
    end
  end

  
end
