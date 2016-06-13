class Corder < ActiveRecord::Base
  belongs_to :cart

  require "active_merchant/billing/rails"

  CardTypes = [
    ['Visa', 'visa'],
    ['MasterCard', 'master'],
    ['Discover', 'discover'],
    ['American Express', 'american_express']
  ]



  validates_presence_of :first_name, :last_name, :phone, :email, :price, :schools, :district
  validates_presence_of :address, :city, :state, :zip_code, :card_type, :card_expires_on, :if => :free?

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_length_of :phone, :minimum => 7, :too_short => 'must be at least 7 numbers'
  
  attr_accessor :card_number, :card_verification, :clearance
  
  before_create :send_purchase, :if => :free?

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
    order = find_by_id(row["id"])
    order.attributes = row.to_hash.slice(*["id", "processed"])
    order.save
    end
  end

  private 

  def purchase_address
    {
      :address1 => address,
      :city => city,
      :state => state,
      :zip => zip_code,
      :country => 'US'
    }
  end
  
  def send_purchase
    if credit_card.valid?
      response = GATEWAY.purchase(price_in_cents, credit_card)
      logger.debug "[gateway response] #{@clearance.inspect}"
      unless response.success?
        logger.debug "[response error] #{@clearance.message}"
        errors.add :base, @clearance.message
      end
    else
      credit_card.errors.each do |key, msg|
        logger.debug "[credit_card error] #{key}: #{msg}"
        errors.add key, msg
      end
      false
    end
  end

  def price_in_cents
    (price*100).round
  end
  
  
  # returns credit card object
  
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :brand              => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end
end