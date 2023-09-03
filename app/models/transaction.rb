class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :token
  validates :usd_value, presence: true, numericality: true
end
