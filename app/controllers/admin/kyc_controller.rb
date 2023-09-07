
class Admin::KycController < ApplicationController
    #before_action :authenticate_admin!
  
    def index
      # Retrieve pending KYC requests
      #@users_with_pending_kyc = User.where(kyc_status: 'pending')
      #pending_kyc_records = Kyc.where(status: 'pending')
      
      # Render the pending KYC requests as JSON
      users_with_pending_kyc = User.includes(:kyc).where(kyc_status: 'pending')
      response_data = users_with_pending_kyc.map do |user|
        {
          id: user.id,
          email: user.email,
          fullName: user.kyc.fullName,
          birthday: user.kyc.birthday,
          address: user.kyc.address
          idType: user.kyc.idType,
          idNumber: user.kyc.idNumber,
          # Add other KYC details here
          kyc_status: user.kyc_status
        }
      end
    
      render json: response_data

      #render json: @users_with_pending_kyc

      # Convert the pending KYC records to JSON and render the response
     # render json: pending_kyc_records
        
    

    end
  
    def approve
      user = User.find(params[:id])
      user.update(kyc_status: 'approved')
      render json: { message: 'KYC approved successfully.' }, status: :ok
      KycMailer.kyc_approved_email(user).deliver_now
      
      
    end
  
    def reject
      user = User.find(params[:id])
      user.update(kyc_status: 'rejected')
      render json: { message: 'KYC rejected.' }, status: :ok
    end
  end
  