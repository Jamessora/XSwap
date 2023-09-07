require 'rails_helper'

RSpec.describe KycController, type: :controller do
  include Devise::Test::ControllerHelpers

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user) { create(:user, :confirmed) }

  let(:valid_kyc_data) {
    { kyc: attributes_for(:kyc) }
  }

  let(:invalid_kyc_data) {
    { kyc: { fullName: '', birthday: '', address: '', idType: '', idNumber: '' } }
  }

  describe "POST #create" do
    context "when user is not authenticated" do
      it "returns unauthorized status" do
        post :create, params: valid_kyc_data
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when user is authenticated" do
      before do
        sign_in user
      end

      context "with valid KYC data" do
        it "returns ok status and a success message" do
          post :create, params: valid_kyc_data
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)["message"]).to eq('KYC submitted successfully.')
        end

        it "updates the user's KYC status to pending" do
          post :create, params: valid_kyc_data
          user.reload
          expect(user.kyc_status).to eq("pending")
        end
      end

      context "with invalid KYC data" do
        it "returns unprocessable_entity status and an error message" do
          post :create, params: invalid_kyc_data
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)["error"]).to eq('Failed to submit KYC data')
        end
      end
    end
  end
end
