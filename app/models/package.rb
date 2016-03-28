class Package < ActiveRecord::Base
	has_many :order_packages, dependent: :destroy
	has_many :carts, through: :order_packages
	
	has_many :options

  has_many :shippings

  has_many :download_images

  has_many :prices

	has_many :student_images

	has_many :school_packages, dependent: :destroy
	has_many :schools, through: :school_packages

  has_many :student_proofs

	accepts_nested_attributes_for :options, allow_destroy: true
  accepts_nested_attributes_for :shippings, allow_destroy: true


  	has_attached_file :image,
  	:styles => { :medium => "300x300>", :thumb => "100x100>" },
  	:url => ':s3_domain_url',
  	:path => '/images/package_types/:id/:filename'
  	  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  	has_attached_file :banner,
  	:styles => { :medium => "300x300>", :thumb => "100x100>" },
  	:url => ':s3_domain_url',
  	:path => '/images/banners/:id/:style/:filename'
  	validates_attachment_content_type :banner, :content_type => /\Aimage\/.*\Z/

    def price school = nil
    prices.where('school_id = ? OR school_id IS NULL', school).where('end > ? OR end IS NULL', Time.now).where('begin < ? OR begin IS NULL', Time.now).order('school_id DESC, end DESC, begin DESC').first.price rescue 0
  end



    def self.concat order_id, student_id
      @string = ""
      ids = [37, 38, 39, 40, 41, 42, 43, 2, 9, 36, 11]
      order = Order.find(order_id)
      student = Student.find(student_id)

      order.cart.order_packages.where(:student_id => student.id).each_with_index do |o, i|
        @cat = ""
        @string = ""
        oids = o.extras.pluck(:id)
        if oids.include? ids[0]
          @cat = @cat + "#{Extra.find(37).quantity}"
        elsif oids.include? ids[10]
          @cat = @cat + "#{Extra.find(11).quantity}"
        else
          @cat = @cat + "0"
        end

        if oids.include? ids[1]
          @cat = @cat + "#{Extra.find(38).quantity}"
        else
          @cat = @cat + "0"
        end

        if oids.include? ids[2]
          @cat = @cat + "#{Extra.find(39).quantity}"
        else
          @cat = @cat + "0"
        end

        if oids.include? ids[3]
          @cat = @cat + "#{Extra.find(40).quantity}"
        elsif oids.include? ids[7]
          @cat = @cat + "#{Extra.find(2).quantity}"
        else
          @cat = @cat + "0"
        end

        if oids.include? ids[4]
          @cat = @cat + "#{Extra.find(41).quantity}"
        else
          @cat = @cat + "0"
        end

        if oids.include? ids[5]
          @cat = @cat + "#{Extra.find(42).quantity}"
        else
          @cat = @cat + "0"
        end

        if oids.include? ids[6]
          @cat = @cat + "#{Extra.find(43).quantity}"
        elsif oids.include? ids[8]
          @cat = @cat + "#{Extra.find(9).quantity}"
        elsif oids.include? ids[9]
          @cat = @cat + "#{Extra.find(36).quantity}"
        else
          @cat = @cat + "0"
        end


          @string = "#{@string}" + "#{@cat}; "
 
      end
      return @string
    end
end
