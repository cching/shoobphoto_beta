class ExportData < ActiveRecord::Base

  belongs_to :user
  belongs_to :type
  has_many :export_data_students
  has_many :students, through: :export_data_students, dependent: :destroy
  has_many :schools, through: :students
  belongs_to :template
  
  serialize :prompt_values, Hash
  
  has_attached_file :file, path: '/export_files/:id/:filename',:s3_host_name => 's3-us-west-1.amazonaws.com', use_timestamp: false
  do_not_validate_attachment_file_type :file

  validates_presence_of :kind
  validates_presence_of :certificate_title, :distribution_date, if: :is_request?
  validates_presence_of :type, if: :is_print?
  
  # Override to optimize insert statements into one statement.
  def autosave_associated_records_for_students
    if association = association_instance_get(:students)
      if records = associated_records_to_validate_or_save(association, @new_record_before_save, false)
        if records.any?
          begin
            values = records.map do |record|
              "(#{record.id},#{id})"
            end.join(',')
            Student.connection.execute(%(INSERT INTO export_data_students ("student_id", "export_data_id") VALUES #{values}))
          rescue
            raise ActiveRecord::Rollback
          end
        end
      end
      association.send(:reset_scope) if association.respond_to?(:reset_scope)
    end
  end
  
  def template
    pdf.try(:template)
  end
  
  def pdf
    type.try(:pdf)
  end
  
  # Create methods to see if the export is a certain kind.
  ExportJob.kinds.each do |t|
    define_method "is_#{t}?" do
      kind == t
    end
  end
  
  
  # Return the format for the given export.
  def format
    { 'print' => :pdf, 'zpass' => :csv }[kind]
  end
  
  # Return the content type for the given export.
  def content_type
    { 'print' => 'application/pdf', 'zpass' => 'text/plain' }[kind]
  end
  
  # Returns all columns in the template.
  def columns
    template ? template.fields.map(&:column_name) : []
  end
  
  private
  
  def students_count
    unless students.count > 0
      errors.add :base, 'You must export at least one student.'
    end
  end
  
  # If columns includes image or school mascot image, ensure each student has
  # an image and their school has a mascot image.
  def image_presence
    if (columns | ExportJob.necessary_image_columns).present?
      image_present = columns.include?('image')
      mascot_present = columns.include?('school_mascot_image')
      
      students.each do |student|
        if image_present && !student.image?
          errors.add :base, 'Exported students must each have an image for this template'
          break
        elsif mascot_present && !student.school.mascot_image?
          errors.add :base, 'Exported students\' schools must have a mascot image for this template'
          break
        end
      end
    end
  end
  
  # If color columns are present in the template, ensure all students have a
  # bus route with a color value.
  def color_presence
    if (columns | ExportJob.color_columns).present?
      bus_route_present = columns.include?('bus_route_color_value')
      
      students.each do |student|
        if bus_route_present && student.bus_route_color_value.blank?
          errors.add :base, 'Exported students must each have a bus route with a color'
          break
        end
      end
    end
  end
end
