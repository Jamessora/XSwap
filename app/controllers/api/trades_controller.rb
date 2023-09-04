    class Api::TradesController < ApplicationController
        before_action :authenticate_user!


        def buy
            token_ticker = params[:token]
            amount = params[:amount]
            total_usd_value = params[:total_usd_value].to_f
            
            per_token_price = total_usd_value / amount
            puts "Creating transaction with params: #{params.inspect}"
            puts "Found Token: #{Token.find_by_ticker(token_ticker).inspect}"

            
            # found_token = Token.find_by_ticker(token_ticker)
            # unless found_token
            #   render json: { success: false, message: 'Token does not exist' }, status: :unprocessable_entity
            #   return
            # end

            token = Token.find_or_create_by(ticker: token_ticker) do |new_token|
                new_token.name = token_ticker.capitalize
                new_token.price = per_token_price
            end

            transaction = Transaction.create(
                transaction_type: 'buy',
                transaction_amount: amount,
                transaction_price: per_token_price,
                usd_value: total_usd_value,
                user: current_user,
                token: token
            )
            
            puts "Transaction errors: #{transaction.errors.full_messages}" if transaction.errors.any?

            if transaction.persisted?
                current_user.update(balance: current_user.balance - total_usd_value)

                portfolio_item = PortfolioItem.find_or_initialize_by(user: current_user, token: token)

                # Update the amount
                if portfolio_item.amount.nil?
                portfolio_item.amount = 0
                end
                portfolio_item.amount += amount # 'amount' is the amount being bought

                # Save the portfolio item
                portfolio_item.save


                render json: { success: true, message: 'Buy successful', transaction: transaction }, status: :created
            else
                render json: { success: false, message: 'Buy failed', errors: transaction.errors.full_messages }, status: :unprocessable_entity
            end
        end

        def sell
            token_ticker = params[:token]
            amount = params[:amount]
            total_usd_value = params[:total_usd_value].to_f  
            
            per_token_price = total_usd_value / amount
            puts "Creating transaction with params: #{params.inspect}"
            puts "Found Token: #{Token.find_by_ticker(token_ticker).inspect}"

            
            token = Token.find_by(ticker: token_ticker)
            
            
            if token.nil?
                render json: { success: false, message: 'Token not found', errors: ["Token must exist"] }, status: :unprocessable_entity
                return
            end

            portfolio_item = PortfolioItem.find_by(user: current_user, token: token)

            # Check if the user has the token in their portfolio
            if portfolio_item.nil?
                render json: { success: false, message: 'Token not found in your portfolio', errors: ["You don't have enough #{token_ticker} tokens"] }, status: :unprocessable_entity
                return
            end
            
            # Check if the user has enough tokens to sell
            if portfolio_item.amount < amount
                render json: { success: false, message: 'Not enough tokens', errors: ["You don't have enough #{token_ticker} tokens"] }, status: :unprocessable_entity
                return
            end

        # Create transaction
            transaction = Transaction.create(
                transaction_type: 'sell',
                transaction_amount: amount,
                transaction_price: per_token_price,
                usd_value: total_usd_value,
                user: current_user,
                token: token
            )

            
            puts "Transaction errors: #{transaction.errors.full_messages}" if transaction.errors.any?

            if transaction.persisted?
                current_user.update(balance: current_user.balance + total_usd_value)

                # Update the amount if the portfolio item exists
                if portfolio_item
                portfolio_item.amount -= amount # 'amount' is the amount being sold
                portfolio_item.save
                end
            
                render json: { success: true, message: 'Sell successful', transaction: transaction }, status: :created
            else
                render json: { success: false, message: 'Sell failed', errors: transaction.errors.full_messages }, status: :unprocessable_entity
            end
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
                else # Assuming "sell"
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

          private

          def fetch_current_price(pair)
            require 'rest-client'
            require 'json'
            response = RestClient.get "https://api.coingecko.com/api/v3/simple/price?ids=#{pair}&vs_currencies=usd"
            json_data = JSON.parse(response.body)
            json_data[pair]['usd']
          end

    end
