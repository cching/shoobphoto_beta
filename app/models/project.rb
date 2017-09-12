class Project < ActiveRecord::Base
	has_many :project_prints
	has_many :prints, through: :project_prints
	has_many :porders

	validates_presence_of :name, :email, :position, :school
	validates_format_of :email, :with => /@/
    validates_length_of :phone, :minimum => 7, :too_short => 'must be at least 7 numbers'

	accepts_nested_attributes_for :project_prints, allow_destroy: true

	def price
		@price = 0
		project_prints.map { |pprint| @price += (pprint.print.price*pprint.quantity) }

		project_prints.each do |pprint| 
			if !pprint.print_style_id.nil?
				@price += pprint.print_style.price
			end

			if !pprint.print_size_id.nil?
				@price += pprint.print_size.price
			end
		end

		return @price
	end
end
