class YearbookPdf < Prawn::Document
  def initialize(carts, yearbooks, school)
    super(top_margin: 70)
    @carts = Cart.find(carts.map(&:to_i))
    @yearbooks = Yearbook.find(yearbooks.map(&:to_i))
    @school = School.find(school.to_i) 
    first_table

  end
def items
    @carts.map do |cart|
       cart.students.where(:school_id => @school.id).order(:last_name).map do |student| 
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
  table([["Student", "Grade", "Teacher", "Date", "Quantity", "Price"], [(items)]], width: 500, :position => :center) do
    row(0).align = :center
    row(0).font_style = :bold
    row(0).background_color = '82b3e7'
    row(0).text_color = 'ffffff'
  end
  
  

end





end



              
              
              
               
            
                       
