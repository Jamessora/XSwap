require 'rails_helper'
require 'webmock/rspec'

    RSpec.describe Api::TradesController, type: :controller do
    include Devise::Test::ControllerHelpers

    before :each do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        @user = create(:user, :confirmed, :with_kyc)
        @token = create(:token, id:'bitcoin', ticker: 'BTC', name: 'Bitcoin', price: 27000.0)
        sign_in @user

        # Stubbing the external request
        WebMock.stub_request(:get, /https:\/\/api\.coincap\.io\/v2\/assets\/.*\?interval=d1/)
            .to_return(
                status: 200,
                body: '{"data": {"priceUsd": "27000.0"}}',
                headers: {}
            )
    end

    

    describe "POST #buy" do
        context "with insufficient balance" do
          it "returns unprocessable entity status" do
            post :buy, params: { token: 'BTC', amount: 1.0, total_usd_value: 27001.0 }
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)["message"]).to eq('Insufficient balance')
          end
        end
    
        context "with sufficient balance and valid params" do
          it "creates a new buy transaction and updates user balance and portfolio" do
            post :buy, params: { token: 'BTC', amount: 0.01, total_usd_value: 27000.0 }
            expect(response).to have_http_status(:created)
            expect(@user.reload.balance).to eq(1000.0 - 270.0)
            expect(PortfolioItem.find_by(user: @user, token: @token).amount).to eq(0.01)
          end
        end
      end
    
      describe "POST #sell" do
        context "with insufficient tokens" do
          it "returns unprocessable entity status" do
            post :sell, params: { token: 'BTC', amount: 1.0, total_usd_value: 27000.0 }
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)["message"]).to eq('Token not found in your portfolio')
          end
        end
    
        context "with sufficient tokens and valid params" do
          before do
            create(:portfolio_item, user: @user, token: @token, amount: 1.0)
          end
    
          it "creates a new sell transaction and updates user balance and portfolio" do
            post :sell, params: { token: 'BTC', amount: 0.5, total_usd_value: 13500.0 }
            expect(response).to have_http_status(:created)
            expect(@user.reload.balance).to eq(1000.0 + 13500.0)
            expect(PortfolioItem.find_by(user: @user, token: @token).amount).to eq(0.5)
          end
        end
      end
    


    
end