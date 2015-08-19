class AddSchoolIdToCart < ActiveRecord::Migration
  def up
  	add_column :carts, :school_id, :integer
  end
end
