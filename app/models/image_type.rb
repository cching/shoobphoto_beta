class ImageType < ActiveRecord::Base
	belongs_to :option

	def self.count id
		image_type = ImageType.find(id)

		if image_type.name.include? "5x7"
			return image_type.name.gsub(/[\s+)(]/,"")[0,1].to_i/2
		elsif image_type.name.include? "Wallets"
			return image_type.name.gsub(/[\s+)(]/,"")[0,2].to_i/8
		else
			return image_type.name.gsub(/[\s+)(]/,"")[0,1].to_i
		end
		
	end

	def self.name_out id
		image_type = ImageType.find(id)

		s = image_type.name.gsub(/[\s+)(]/,"")
		
		if s.include? "Wallets"
			return "Wallets"
		else
		s.slice!(0)
		return s
		end
		
	end

	def self.classname id
		image_type = ImageType.find(id)

		s = image_type.name.gsub(/[\s+)(]/,"")
		
			s.slice!(0)
		

		if s == "8x10"
			return "eightbyten"
		elsif s == "5x7"
			return "fivebyseven"
		elsif s == "11x14"
			return "elevenbyfourteen"
		elsif s == "16x20"
			return "sixteenbytwenty"
		elsif s.include? "Wallet"
			return "wallets"
		end
	end

end
