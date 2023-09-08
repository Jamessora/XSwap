class Admin::RegistrationsController < Devise::RegistrationsController
    respond_to :json

    def is_flashing_format?
        false
      end
    
    private
    def respond_with(resource, _opts = {})
        puts "Debugging: Resource attributes: #{resource.attributes}"
        puts "Debugging: Resource errors: #{resource.errors.full_messages}"
    
        
        register_success && return if resource.persisted?

        register_failed
    end

    def register_success
        render json: {
            message: 'Signed up successfully.',
            
        }, 
        status: :ok
    end

    def register_failed
        render json: {
            message: "Admin couldn't be created, signed up failed.",
            errors: resource.errors.full_messages
        },
        status: :unprocessable_entity
    end
end      