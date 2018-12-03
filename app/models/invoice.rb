class Invoice < ActiveRecord::Base
    has_many :lineitems, dependent: :destroy
    belongs_to :dproject

    accepts_nested_attributes_for :lineitems

  
end 