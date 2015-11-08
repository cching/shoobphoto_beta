class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)

      	chunk.each do |h|

      		item = Item.find_by_number(h["itemnum"])

      		unless item.nil?

      		category = Category.where("lower(name) like ?", "#{h["category"].downcase}")

      		if category.any?
      			category = category.last
      		else
      			category = category.create(:name => "#{h["category"].upcase}")
      		end
      		subcategory = Subcategory.where("lower(name) like ?", "#{h["subcategory"].downcase}")

      			if subcategory.any?
      				subcategory = subcategory.last
				else
      				subcategory = category.subcategories.create(:name => "#{h["category"].upcase}")
      			end
      		
      		item.update(:subcategory_id => subcategory.id)

      		array = h["searchterm"].split ","

      		array.each do |term|
      			searchterm = Searchterm.where("lower(name) like ?", "#{term.downcase}")

      			if searchterm.any?
      				searchterm = searchterm.last
      			else
      				searchterm = searchterm.create(:name => "#{term}")
      			end
      			item.searchterms << searchterm
      		end

      		
	          #  school = School.find_by_ca_code(h["ca_code"].to_s)
	            #unless school.nil?
	           #	school.users.create(:email => h["email"], :password => h["password"], :password_confirmation => h["password_confirmation"])
	        end #end if
	          	
	        
     	end #end chunk
 	end
end