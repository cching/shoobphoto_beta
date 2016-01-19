class NavLink < ActiveRecord::Base
  acts_as_nested_set
    
  
  validates_presence_of :title



  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
    id = NavLink.last.id + 1
    navlink = NavLink.new(:id => id)
    navlink.attributes = row.to_hash.slice(*["title", "slug", "parent_id", "position"])
    navlink.save!
    end
  end
  

   
  def path
    "/#{self_and_ancestors.map(&:slug).join('/')}"
  end
  
  

end
