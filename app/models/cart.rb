class Cart < ActiveRecord::Base
	has_many :cart_students, dependent: :destroy
	has_many :students, through: :cart_students
	
	has_many :order_packages, dependent: :destroy
	has_many :packages, through: :order_packages

	has_many :cart_items, dependent: :destroy
	has_many :items, through: :cart_items

	has_many :cart_teams, dependent: :destroy
	has_many :teams, through: :cart_teams

	has_many :orders
	has_many :corders

	accepts_nested_attributes_for :order_packages, allow_destroy: true
	accepts_nested_attributes_for :cart_items, allow_destroy: true
	belongs_to :school
  	
	def to_param
  		cart_id
	end
 
	def paypal_url(return_url)
    values = {
      :business => "merchant@shoobphoto.com",
      :cmd => "_cart",
      :upload => 1,
      :return => return_url,
      :invoice => cart_id
    }
    
    @index = 0
    order_packages.each do |opackage|
      values.merge!({
        "amount_#{@index + 1}" => opackage.options.first.price,
        "item_name_#{@index + 1}" => "#{opackage.package.name}: #{opackage.options.first.name}",
        "item_number_#{@index + 1}" => opackage.options.first.id,
        "quantity_#{@index + 1}" => 1
      })
      @index = @index + 1
    end

    order_packages.each do |opackage|
      opackage.extras.each do |extra|
      values.merge!({
        "amount_#{@index + 1}" => extra.prices.first.try(:price),
        "item_name_#{@index + 1}" => "#{opackage.package.name}: #{extra.name}",
        "item_number_#{@index + 1}" => extra.id,
        "quantity_#{@index + 1}" => 1
      })
      @index = @index + 1
      end
    end

    order_packages.each do |opackage|
      opackage.addon_sheets.each do |addon|
        option = opackage.options.first
        if option.without?
          values.merge!({
            "amount_#{@index + 1}" => addon.addon.price_without,
            "item_name_#{@index + 1}" => "#{opackage.package.name}: #{addon.addon.name}",
            "item_number_#{@index + 1}" => addon.addon.id,
            "quantity_#{@index + 1}" => 1
          })
        else
          values.merge!({
            "amount_#{@index + 1}" => addon.addon.price_with,
            "item_name_#{@index + 1}" => "#{opackage.package.name}: #{addon.addon.name}",
            "item_number_#{@index + 1}" => addon.addon.id,
            "quantity_#{@index + 1}" => 1
          })
        end
      @index = @index + 1
      end
    end

    if order_packages.where.not(package_id: nil).first.package.shippings.any?
      values.merge!({
        "amount_#{@index + 1}" => order_packages.where.not(package_id: nil).first.package.shippings.first.price,
        "item_name_#{@index + 1}" => "Shipping",
        "item_number_#{@index + 1}" => "Shipping",
        "quantity_#{@index + 1}" => 1
      })
      @index = @index + 1
    end

    order_packages.each do |opackage|
      if opackage.try(:extra_poses) != 0 && opackage.try(:extra_poses) != nil
      values.merge!({
        "amount_#{@index + 1}" => opackage.try(:extra_poses)*25,
        "item_name_#{@index + 1}" => "Extra Pose",
        "item_number_#{@index + 1}" => "Extra Pose",
        "quantity_#{@index + 1}" => opackage.try(:extra_poses)
      })
      @index = @index + 1
    end
    end



    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end
end


