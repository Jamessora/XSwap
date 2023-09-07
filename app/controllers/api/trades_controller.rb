class Api::TradesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_token, only: [:buy, :sell, :price]
    before_action :set_transaction_params, only: [:buy, :sell]
    
    def buy
        if @total_usd_value > current_user.balance
          render json: { success: false, message: 'Insufficient balance' }, status: :unprocessable_entity
          return
        end
    
        create_transaction('buy')
        update_portfolio_item(@amount)
      end
      
    
    def sell
        portfolio_item = PortfolioItem.find_by(user: current_user, token: @token)

        puts "Initial portfolio item amount: #{portfolio_item&.amount || 'Portfolio item not found'}"
        if portfolio_item.nil? || portfolio_item.amount < @amount.to_f
          render json: { success: false, message: 'Insufficient tokens', errors: ["You don't have enough #{@token_ticker} tokens"] }, status: :unprocessable_entity
          return
        end
    
        create_transaction('sell')
        update_portfolio_item(-@amount)
      end
  

    def calculate_pnl
        @transactions = Transaction.where(user_id: current_user.id)
        pnls = [] # Hash to store the PNL for each token
    
        # Get unique token ids
        unique_tokens = @transactions.pluck(:token_id).uniq
    
        unique_tokens.each do |token_id|
        # Filter transactions for the current token
        token_transactions = @transactions.where(token_id: token_id)
        
        puts "Calculated PNLs: #{pnls.inspect}"

        remaining_usd_value = 0
        remaining_amount_of_token = 0
    
        token_transactions.each do |transaction|
            if transaction.transaction_type == "buy"
            remaining_usd_value += transaction.transaction_amount * transaction.transaction_price
            remaining_amount_of_token += transaction.transaction_amount
            else # "sell"
            remaining_usd_value -= transaction.transaction_amount * transaction.transaction_price
            remaining_amount_of_token -= transaction.transaction_amount
            end
        end
    
        # Fetch the current price
        token = Token.find(token_id)
        current_price = token.price
        current_usd_value = remaining_amount_of_token * current_price
    
        pnl = current_usd_value - remaining_usd_value
        
        pnls.push({ token: token.name, pnl: pnl })
        end
    
        # pnls now contains the PNL for each token
        render json: { pnls: pnls }
    end

   

    def price
        token_id = params[:pair]
        token_data = fetch_token_data(token_id)
      
        if token_data
          token = Token.find_or_create_by(external_id: token_data['id']) do |new_token|
            new_token.ticker = token_data['symbol'].downcase
            new_token.name = token_data['name']
            new_token.price = token_data['priceUsd']
          end
      
          # If the token was found, we update its data
          if token.persisted?
            token.update(
              ticker: token_data['symbol'].downcase,
              name: token_data['name'],
              price: token_data['priceUsd']
            )
          end
      
          render json: { status: 'success', data: token_data }, status: :ok
        else
          render json: { status: 'error', message: 'Failed to fetch token data' }, status: :internal_server_error
        end
      end

    

      private

      def set_token
        @token_ticker = params[:token]
        @token = Token.find_or_initialize_by(ticker: @token_ticker) do |new_token|
          new_token.name = @token_ticker.capitalize
        end
        @token.update(price: fetch_current_price_new(@token_ticker))
      end

      def set_transaction_params
        @amount = params[:amount].to_f
        @total_usd_value = params[:total_usd_value].to_f
      end


      def create_transaction(type)
        transaction = Transaction.create(
          transaction_type: type,
          transaction_amount: @amount,
          transaction_price: @token.price,
          usd_value: @total_usd_value,
          user: current_user,
          token: @token
        )
        
        if transaction.persisted?
          current_user.update(balance: current_user.balance + (@total_usd_value * (type == 'sell' ? 1 : -1)))
          render json: { success: true, message: "#{type.capitalize} successful", transaction: transaction, user: { balance: current_user.balance } }, status: :created
        else
          render json: { success: false, message: "#{type.capitalize} failed", errors: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update_portfolio_item(amount_change)
        portfolio_item = PortfolioItem.find_or_initialize_by(user: current_user, token: @token)
        
        puts "Before update, portfolio_item amount: #{portfolio_item.amount || 0}"
        puts "Amount change: #{amount_change}"

        portfolio_item.amount = (portfolio_item.amount || 0) + amount_change.to_f
        portfolio_item.save

        puts "After update, portfolio_item amount: #{portfolio_item.amount}"
      end
        
        def fetch_current_price_new(token_id)
        require 'rest-client'
        require 'json'
      
        response = RestClient.get "https://api.coincap.io/v2/assets/#{token_id}?interval=d1"
        data = JSON.parse(response.body)
      
        if data['data']
            return data['data']['priceUsd'].to_f
        else
            # handle error
            return nil
        end
        end

        def fetch_token_data(token_id)
        require 'rest-client'
        require 'json'

        response = RestClient.get "https://api.coincap.io/v2/assets/#{token_id}?interval=d1"
        data = JSON.parse(response.body)

        if data['data']
            return data['data']
        else
            # handle error
            
        return nil
        end
            rescue RestClient::ExceptionWithResponse => e
            Rails.logger.error "Error fetching data from API: #{e.response}"
            return nil
        
       end
    #   

      

end
