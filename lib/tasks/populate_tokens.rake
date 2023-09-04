namespace :tokens do
    desc "Populate database with tokens from CoinGecko API"
    task populate: :environment do
      require 'rest-client'
      require 'json'
  
      response = RestClient.get 'https://api.coingecko.com/api/v3/coins/list'
      tokens = JSON.parse(response.body)
  
      tokens.each do |token|
        Token.find_or_create_by(external_id: token['id']) do |new_token|
          new_token.name = token['name']
          new_token.ticker = token['symbol']
        end
      end
  
      puts "Tokens populated successfully!"
    end
  end
  