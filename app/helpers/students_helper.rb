module StudentsHelper

  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
end
	def self.find_by_school(school)
    school = School.find(school.id) #params?
    @student = []
    bucket = AWS::S3::Bucket.new('shoobphoto')
    school.students.each do |student|
    
      unless student.grad_id.nil?
        unless AWS::S3::S3Object.new(bucket, "images/graduations2015/#{student.grad_id.upcase}.jpg").exists? || AWS::S3::S3Object.new(bucket, "images/graduations2015/#{student.grad_id.downcase}.jpg").exists?
          @student << student
        end
      end

      unless student.senior_id.nil?
        unless AWS::S3::S3Object.new(bucket, "images/seniors2015/#{student.senior_id.upcase}.jpg").exists? || AWS::S3::S3Object.new(bucket, "images/seniors2015/#{student.senior_id.downcase}.jpg").exists?
          @student << student
        end
      end
    end 

    return @student.uniq
  end

  def find_by_school(school)
    StudentsHelper.find_by_school(school)
  end


  def grad_missing(student)
    bucket = AWS::S3::Bucket.new('shoobphoto')
    unless student.grad_id.nil?
      if AWS::S3::S3Object.new(bucket, "images/graduations2015/#{student.grad_id.upcase}.jpg").exists? || AWS::S3::S3Object.new(bucket, "images/graduations2015/#{student.grad_id.downcase}.jpg").exists?
        return false
      else
        return true
      end
    end
  end

  def senior_missing(student)
    bucket = AWS::S3::Bucket.new('shoobphoto')
    unless student.senior_id.nil?
      if AWS::S3::S3Object.new(bucket, "images/seniors2015/#{student.senior_id.upcase}.jpg").exists? || AWS::S3::S3Object.new(bucket, "images/seniors2015/#{student.senior_id.downcase}.jpg").exists?
        return false
      else 
        return true
      end
    end
  end

end
