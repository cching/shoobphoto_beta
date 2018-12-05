class Lineitem < ActiveRecord::Base
    belongs_to :invoice
    belongs_to :dprojects
     
     def total
        self.extended_price ||=0.0 
        self.extended_price = price * quantity
    end 
    def tax
        self.sales_tax = total * 0.0725
    end 
    def final 
        self.final_price = total + tax
    end 
end
