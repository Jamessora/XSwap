require 'rails_helper'

RSpec.describe Users::ConfirmationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET #show" do
    let!(:user) { create(:user, confirmed_at: nil, confirmation_token: "validToken") }

    context "with a valid confirmation token" do
      before do
        get :show, params: { confirmation_token: "validToken" }
      end

      it "confirms the user" do
        user.reload
        expect(user.confirmed_at).not_to be_nil
      end

      it "redirects to the after confirmation path for the user" do
        expect(response).to redirect_to("https://xswap-fe.onrender.com/confirmation-success?status=success")
      end
    end

    context "with an invalid confirmation token" do
      before do
        get :show, params: { confirmation_token: "invalidToken" }
      end

      it "does not confirm the user" do
        user.reload
        expect(user.confirmed_at).to be_nil
      end

      it "redirects to the new confirmation path" do
        expect(response).to redirect_to("https://xswap-fe.onrender.com/confirmation-success?status=failure")
      end
    end
  end
end
