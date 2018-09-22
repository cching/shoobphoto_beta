class Search < ActiveRecord::Base

	def orders
    @orders ||= find_orders
  end
  
private
  def find_orders
    orders = Order.where('created_at >= :ninety_days_ago', :ninety_days_ago  => Time.now - 90.days).order("processed ASC")
    students = Student.all

    students = students.where('lower(students.first_name) like ?', "%#{student_first_name.downcase}%") if student_first_name.present?
    students = students.where('lower(students.last_name) like ?', "%#{student_last_name.downcase}%") if student_last_name.present?
    carts = CartStudent.where(student_id: students.pluck(:id)) if student_last_name.present? || student_first_name.present?
    orders = Order.where(cart_id: carts.pluck(:cart_id)) if student_last_name.present? || student_first_name.present?
    students = students.where('students.school_id = ?', "#{school_id}") if school_id.present?
    carts = CartStudent.where(student_id: students.pluck(:id)) if school_id.present?
    orders = orders.where(cart_id: carts.pluck(:cart_id)) if school_id.present? 
    orders = orders.where("id = ?", "#{order_id.to_i}") if order_id.present?
    orders = orders.where("lower(first_name) like ?", "%#{first_name.downcase}%") if first_name.present?
    orders = orders.where("lower(last_name) like ?", "%#{last_name.downcase}%") if last_name.present?
    orders = orders.where("phone like ?", "%#{phone}%") if phone.present?
    orders = orders.where("shiping_zip like ?", "%#{zip}%") if zip.present?
    orders = orders.where("billing_zip like ?", "%#{billing_zip}%") if billing_zip.present?
    orders = orders.where("lower(shipping_city) like ?", "%#{city.downcase}%") if city.present?
    orders = orders.where("lower(city) like ?", "%#{billing_city.downcase}%") if billing_city.present?
    orders = orders.where("lower(address) like ?", "%#{billing_address.downcase}%") if billing_address.present?
    orders = orders.where("lower(shipping_address) like ?", "%#{address.downcase}%") if address.present?
    orders = orders.where("lower(card_type) like ?", "%#{card_type.downcase}%") if card_type.present?
    orders = orders.where("lower(email) like ?", "%#{email.downcase}%") if email.present?
    orders = orders.where("processed = ?", "#{processed}") if processed.present?
    orders
  end
end
