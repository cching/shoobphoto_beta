class RenderWatermark
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(student_id)
      student = Student.find(student_id)
      school = student.school
      bucket = AWS::S3::Bucket.new('shoobphoto')
      s3 = AWS::S3.new
      bucket1 = s3.buckets["shoobphoto"]

      if student.download_images.any?
        bucket = AWS::S3::Bucket.new('shoobphoto')
        s3 = AWS::S3.new
        bucket1 = s3.buckets["shoobphoto"]

        student.download_images.each do |image|
        unless image.image_file_name.nil? || image.image_file_name == ""
          unless image.watermark.exists?
          if AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.upcase}.jpg").exists?
          image.update(:image_file_name => image.image_file_name.upcase)
          obj1 = bucket.objects["images/#{image.folder}/#{image.image_file_name}.jpg"]
          obj2 = bucket.objects["images/watermarks/download_images/#{image.id}/original/#{image.image_file_name}.jpg"]
          obj1.copy_to(obj2)
          image.update(:watermark_file_name => image.image_file_name)
          image.watermark.reprocess!
          elsif AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.downcase}.jpg").exists?
          image.update(:image_file_name => image.image_file_name.downcase)
          obj1 = bucket.objects["images/#{image.folder}/#{image.image_file_name}.jpg"]
          obj2 = bucket.objects["images/watermarks/download_images/#{image.id}/original/#{image.image_file_name}.jpg"]
          obj1.copy_to(obj2)
          image.update(:watermark_file_name => image.image_file_name)
          image.watermark.reprocess!
        end #end if
      end
        end #end unless
        end #end loop
      end #end if

        school.packages.each do |package|
        images = student.student_images.where(:package_id => package.id)

        if images.any?
          image = images.last

          if image.watermark_file_name.nil?
          if package.multiple?
            for attribute in ['url', 'url1', 'url2', 'url3', 'url4']
              unless image.attributes[attribute].nil? || image.attributes[attribute] == ""
                if AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.attributes[attribute].upcase}.jpg").exists?
                  image.update(:"#{attribute}" => image.attributes[attribute].upcase)
                  obj1 = bucket.objects["images/#{image.folder}/#{image.attributes[attribute]}.jpg"]
                  obj2 = bucket1.objects["images/watermarks/#{image.id}/original/#{image.attributes[attribute]}.jpg"]
                  obj1.copy_to(obj2)
                  image.update(:watermark_file_name => image.attributes[attribute])
                  image.watermark.reprocess!
                elsif AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.attributes[attribute].downcase}.jpg").exists?
                  image.update(:"#{attribute}" => image.attributes[attribute].downcase)
                  obj1 = bucket.objects["images/#{image.folder}/#{image.attributes[attribute]}.jpg"]
                  obj2 = bucket1.objects["images/watermarks/#{image.id}/original/#{image.attributes[attribute]}.jpg"]
                  obj1.copy_to(obj2)
                  image.update(:watermark_file_name => image.attributes[attribute])
                  image.watermark.reprocess!
                end
              end
            end
          else
            image.update(:watermark_file_name => image.image_file_name)
            unless image.watermark.exists?
            unless image.image_file_name.nil? || image.image_file_name == ""
              if AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.upcase}.jpg").exists?
                  image.update(:image_file_name => image.image_file_name.upcase)
                  obj1 = bucket.objects["images/#{image.folder}/#{image.image_file_name}.jpg"]
                  obj2 = bucket.objects["images/watermarks/#{image.id}/original/#{image.image_file_name}.jpg"]
                  obj1.copy_to(obj2)
                  image.update(:watermark_file_name => image.image_file_name)
                  image.watermark.reprocess!
              elsif AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name.downcase}.jpg").exists?
                  image.update(:image_file_name => image.image_file_name.downcase)
                  obj1 = bucket.objects["images/#{image.folder}/#{image.image_file_name}.jpg"]
                  obj2 = bucket.objects["images/watermarks/#{image.id}/original/#{image.image_file_name}.jpg"]
                  obj1.copy_to(obj2)
                  image.update(:watermark_file_name => image.image_file_name)
                  image.watermark.reprocess!
              end
            end
            end
          end # end if
        end
        end
      end
    end
end




          
          