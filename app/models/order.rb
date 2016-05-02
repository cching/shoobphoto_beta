class Order < ActiveRecord::Base
  belongs_to :cart
  delegate :order_packages, :to => :cart, :allow_nil => false
  validates :order_packages, presence: true
  belongs_to :student #for indexing purposes of ransack
  belongs_to :school #for indexing purposes 
  require "active_merchant/billing/rails"

  CardTypes = [
    ['Visa', 'visa'], 
    ['MasterCard', 'master'],
    ['Discover', 'discover'],
    ['American Express', 'american_express']
  ]

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
    order = find_by_id(row["id"])
    order.attributes = row.to_hash.slice(*["id", "processed"])
    order.save
    end
  end

  validates_presence_of :first_name, :last_name, :phone, :email, :address, :city, :state, :zip_code, :card_type, :card_expires_on, :price
  validates_format_of :email, :with => /@/
  validates_length_of :phone, :minimum => 7, :too_short => 'must be at least 7 numbers'
  
  attr_accessor :card_number, :card_verification, :clearance
  
  before_create :send_purchase

  def self.price oid, sid
    order = Order.find(oid)
    @cart = order.cart
    @price = 0


      @cart.order_packages.where(:student_id => sid).each do |package|
        unless package.option.nil?
       @price = package.option.price + @price
     end
      end

      @cart.order_packages.where(:student_id => sid).each do |opackage|
        if opackage.package.shippings.where(:school_id => Student.find(opackage.student_id).school.id).any?
        @price = @price + opackage.package.shippings.where(:school_id => Student.find(opackage.student_id).school.id).first.price
        end
      end

    @cart.order_packages.where(:student_id => sid).each do |o|
      o.extras.each do |e|
        unless e.prices.first.try(:price).nil?
        @price = @price + e.prices.first.price
        end
      end
    end
    return @price
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
        logger.debug "[response error] #{@clearance.try(:message)}"
        errors.add :base, @clearance.try(:message)
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