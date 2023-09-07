class KycController < ApplicationController
  before_action :authenticate_user!
    def create
      user = current_user
    
      unless user
        render json: { error: 'User not found' }, status: :not_found
        return
      end
    
      kyc_data = params.require(:kyc).permit(:fullName, :birthday, :address, :idType, :idNumber)
      kyc_record = user.kyc || user.build_kyc # Build the associated KYC record
    
      if kyc_record.update(kyc_data) # Update the KYC record with new data
        user.update(kyc_status: "pending") # Update the kyc_status of the user
        puts "User KYC Status after update: #{user.kyc_status}"
        puts "User update errors: #{user.errors.full_messages}"
        render json: { message: 'KYC submitted successfully.' }, status: :ok
      else
        render json: { error: 'Failed to submit KYC data', details: kyc_record.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def authenticate_user!
      unless user_signed_in?
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end

  end
  