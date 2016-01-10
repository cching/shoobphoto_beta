class YearbookPdf < Prawn::Document
  def initialize(students, yearbooks, school)
    super(top_margin: 70)
    
    unless yearbooks.nil?
    @yearbooks = Yearbook.find(yearbooks.map(&:to_i))
    end
    unless students.nil?
      @students = Student.find(students.map(&:to_i))
    end
    @school = School.find(school.to_i) 
    first_table


  end
def items
    @students.map do |student|
       student.carts.where(:purchased => true).map do |cart| 
            cart.order_packages.where(:package_id => 7).where(:student_id => student.id).map do |o| 
            [{ content: "#{student.first_name} #{student.last_name}", width: 50, border_bottom_color: '000000', border_top_color: 'ffffff'},
              { content: "#{student.grade}", width: 50, border_bottom_color: '000000', border_top_color: 'ffffff'},
              { content: "#{student.teacher}", width: 50, border_bottom_color: '000000', border_top_color: 'ffffff'},
              { content: "#{cart.created_at}", width: 50, border_bottom_color: '000000', border_top_color: 'ffffff'},
              { content: "1", width: 50, border_bottom_color: '000000', border_top_color: 'ffffff'},
              { content: "#{o.option.price(student.school)}", width: 50, border_bottom_color: '000000', border_top_color: 'ffffff'}
             ]

            end
        end 
    end
  end


  def first_table
    widths = [76,76,76,76,76,76,76]
    width = 532
    cell_height = 20

    table([["Student", "Grade", "Teacher", "Date", "Quantity", "Price", "Payment Type"]], :column_widths => widths)

    unless @students.nil?
    @students.map do |student|
       student.carts.where(:purchased => true).map do |cart| 
            cart.order_packages.where(:package_id => 7).where(:student_id => student.id).map do |o| 
              table([[
              make_cell(:content => "#{student.first_name} #{student.last_name}"),
              make_cell(:content => "#{student.grade}"),
              make_cell(:content => "#{student.teacher}"),
              make_cell(:content => "#{cart.created_at.strftime("%B %d, %Y")}"),
              make_cell(:content => "1"),
              make_cell(:content => "$#{'%.2f' % (o.option.price(student.school))}"),
              make_cell(:content => "Shoob Online")
              ]], :column_widths => widths)
            end
        end
    end
    end
    unless @yearbooks.nil?
    @yearbooks.each do |yearbook|
      if yearbook.amount.nil?
        @price = "0.00"
      else
        @price = '%.2f' % yearbook.amount
      end
     table([[
        make_cell(:content => "#{yearbook.student.first_name} #{yearbook.student.last_name}"),
        make_cell(:content => "#{yearbook.student.grade}"),
        make_cell(:content => "#{yearbook.student.teacher}"),
        make_cell(:content => "#{yearbook.created_at.strftime("%B %d, %Y")}"),
        make_cell(:content => "#{yearbook.quantity}"),
        make_cell(:content => "$#{@price}"),
        make_cell(:content => "#{yearbook.payment_type}")
      ]], :column_widths => widths)
     unless yearbook.notes.nil?
      table([[
        make_cell(:content => "Notes: #{yearbook.notes}")
        ]], :column_widths => width)
     end
  end
  end
end





end



              
              
              
               
            
                       
