require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "POST #create" do
    let(:user) { create(:user, :confirmed) }

    context "with valid email and password" do
      it "renders a successful login message" do
        post :create, params: { user: { email: user.email, password: user.password } }
        expect(JSON.parse(response.body)["message"]).to eq("You are logged in.")
      end

      it "has a status of :ok" do
        post :create, params: { user: { email: user.email, password: user.password } }
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid email or password" do
      it "renders an invalid email or password message" do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }
        expect(JSON.parse(response.body)["error"]).to eq("Invalid email or password.")
      end

      it "has a status of :unauthorized" do
        post :create, params: { user: { email: user.email, password: 'wrongpassword' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with an unconfirmed email" do
      let(:unconfirmed_user) { create(:user) }

      it "renders an email not confirmed message" do
        post :create, params: { user: { email: unconfirmed_user.email, password: 'password123' } }
        expect(JSON.parse(response.body)["error"]).to eq("Please confirm your email before logging in.")
      end

      it "has a status of :unauthorized" do
        post :create, params: { user: { email: unconfirmed_user.email, password: 'password123' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE #destroy" do
        let(:user) { create(:user) }
      
        before do
          # Simulate user login before testing logout
          sign_in user
        end
      
        it "logs out the user" do
          delete :destroy
          expect(subject.current_user).to be_nil
        end
      
        it "returns a successful logout message" do
          delete :destroy
          parsed_response = JSON.parse(response.body)
          expect(parsed_response["message"]).to eq('You have logged out successfully.')
        end

        it "has a status of :ok" do
            delete :destroy
            expect(response).to have_http_status(:ok)
        end
    end

    describe "GET #kyc_status" do
        let(:user) { create(:user, :confirmed) }
    
        context "when user is logged in" do
          it "returns the kyc_status of the user" do
            sign_in user
            get :kyc_status
            expect(JSON.parse(response.body)["kyc_status"]).to eq(user.kyc_status)
          end
    
          it "has a status of :ok" do
            sign_in user
            get :kyc_status
            expect(response).to have_http_status(:ok)
          end
        end
    
        context "when user is not logged in" do
          it "renders an error message" do
            get :kyc_status
            expect(JSON.parse(response.body)["error"]).to eq("User not logged in")
          end
    
          it "has a status of :unauthorized" do
            get :kyc_status
            expect(response).to have_http_status(:unauthorized)
          end
        end
    end
    end
  end

