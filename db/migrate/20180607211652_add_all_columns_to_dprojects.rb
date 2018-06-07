class AddAllColumnsToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :order_num, :integer
  	add_column :dprojects, :contact, :string
  	add_column :dprojects, :contact_email, :string
  	add_column :dprojects, :ptype, :string
  	add_column :dprojects, :due_date, :datetime
  	add_column :dprojects, :must_date, :datetime
  	add_column :dprojects, :print_date, :datetime
  	add_column :dprojects, :proofs_out, :datetime
  	add_column :dprojects, :proofs_in, :datetime
  	add_column :dprojects, :status, :string
  end
end
