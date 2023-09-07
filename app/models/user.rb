class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_validation :set_default_kyc_status, on: :create
  has_one :kyc
  has_many :portfolio_items
  has_many :transactions
  KYC_STATUSES = [nil, 'pending', 'approved', 'rejected', '0']
  after_initialize :set_default_balance, if: :new_record?
  validates :kyc_status, inclusion: { in: KYC_STATUSES }, allow_nil: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password, presence: true, length: { minimum: 6 }, on: :update, if: :password_present?
  devise :database_authenticatable, :registerable, :confirmable, #:recoverable, :rememberable, :validatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  private
  
  def set_default_balance
    self.balance ||= 1000.0
  end
  
  def set_default_kyc_status
    self.kyc_status ||= nil
  end

  def password_present?
    !password.nil? && !password.empty?
  end

end
