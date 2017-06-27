require 'test_helper'

class AutoTest < ActiveSupport::TestCase
  	test "imported students belonging to orders are qualified" do
  		student = Order.last.cart.students.last
  		assert Student.qualified(student), "Student with order should be qualified"
  	end

  	test "qualified students belonging to an order should check if order is qualified" do
  		student = Order.last.cart.students.last

  		if Order.qualified(student) 
  			assert Student.qualified(student), "Order is qualified iff it has an option "
  		end
  	end
end
