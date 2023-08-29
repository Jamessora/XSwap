class TransactionsController < ApplicationController

    def index
        @transactions = current_user.transactions.includes(:token)
        render json: @transactions.as_json(include: { token: { only: :name } })
      end
end
