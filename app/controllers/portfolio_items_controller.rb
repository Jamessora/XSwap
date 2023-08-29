class PortfolioItemsController < ApplicationController
  before_action :authenticate_user!
    def index
      @portfolio_items = PortfolioItem.where(user_id: current_user.id).includes(:token)
      render json: @portfolio_items, include: [:token]
      
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
      end

end
