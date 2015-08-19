module StudentsHelper
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
