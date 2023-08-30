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
  
      def all_transactions
        transactions = Transaction.all
        transactions_data = transactions.map do |transaction|
          user = User.find(transaction.user_id)
          {
            user: user.email,
            transaction_type: transaction.transaction_type,
            transaction_date: transaction.created_at,
            # Replace 'amount' with the correct attribute name from your Transaction model
            amount: transaction.transaction_amount, 
            price: transaction.transaction_price,
            usd_value: transaction.transaction_amount * transaction.transaction_price
          }
        end
        render json: { transactions: transactions_data }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end
      


      private
      
      def user_params
        params.require(:user).permit(:email, :password)
      end

      def trader_update_params
        params.require(:user).permit(:email, :password, :balance, :kyc_status)
      end


end
