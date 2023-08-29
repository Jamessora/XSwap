class Admin::AdminController < ApplicationController
    
      def create_trader
        trader = User.new(user_params)
        trader.confirmed_at = Time.current
        if trader.save
          render json: { message: 'Trader created successfully' }, status: :created
        else
          render json: { errors: trader.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      def update_trader
        trader = User.find(params[:id])
        if trader.update(trader_update_params)
            render json: { message: 'Trader updated successfully' }, status: :ok
          else
            render json: { errors: trader.errors.full_messages }, status: :unprocessable_entity
          end
        end 

      # app/controllers/admin/admin_controller.rb
      def all_traders
        traders = User.all
        render json: traders, status: :ok
      end
      
      # app/controllers/admin/admin_controller.rb
      def show_trader
        trader = User.find(params[:id])
        render json: trader, status: :ok
      end
  


      private
      
      def user_params
        params.require(:user).permit(:email, :password)
      end

      def trader_update_params
        params.require(:user).permit(:email, :password, :balance, :kyc_status)
      end


end
