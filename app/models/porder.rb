class Porder < ActiveRecord::Base
  belongs_to :cart

  require "active_merchant/billing/rails"

  CardTypes = [
    ['Visa', 'visa'],
    ['MasterCard', 'master'],
    ['Discover', 'discover'],
    ['American Express', 'american_express']
  ]


  validates_presence_of :price, :shipping_state, :shipping_city, :shipping_address, :shipping_zip
  validates_presence_of :address, :city, :state, :zip_code, :card_type, :card_expires_on, :if => :free?

  attr_accessor :card_number, :card_verification, :clearance
  
  before_create :send_purchase, :if => :free?

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

  def options
     {:address => {}, :billing_address => purchase_address, :invoice => Corder.last.id + 1}
  end
  
  def send_purchase
    if credit_card.valid?
      response = GATEWAY.purchase(price_in_cents, credit_card, options)
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