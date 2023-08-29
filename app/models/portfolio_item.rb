class PortfolioItem < ApplicationRecord
  belongs_to :user
  belongs_to :token
end
