require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
    include Devise::Test::ControllerHelpers

    before :each do
        @request.env["devise.mapping"] = Devise.mappings[:user]
    end

  describe "POST #create" do
    context "with valid parameters" do
      let(:valid_attributes) {
        
        attributes_for(:user).merge(balance: 1000.0, kyc_status: nil)
      }

      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "redirects to the created user's show page" do
        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["message"]).to eq("Signed up successfully.")
        
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) {
        attributes_for(:user, email: '', password: 'short', password_confirmation: 'short' )
      }

      it "does not create a new User" do
        expect {
          post :create, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)
      end

      it "re-renders the 'new' template" do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["message"]).to eq("User couldn't be created, signed up failed.")
      end
    end
  end
end
