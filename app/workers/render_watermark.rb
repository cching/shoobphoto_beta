class RenderWatermark
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(student_id)
      student = Student.find(student_id)
      school = student.school
      bucket = AWS::S3::Bucket.new('shoobphoto')
      s3 = AWS::S3.new
      bucket1 = s3.buckets["shoobphoto"]
        
      school.packages.each do |package|
        images = student.student_images.where(:package_id => package.id)

        if images.any?
          image = images.last
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
          end # end if
        end
      end

      package = Package.find(6)
      images = student.student_images.where(:package_id => package.id)

      if images.any?
        image = images.last
        for attribute in ['url', 'url1', 'url2', 'url3', 'url4']
          unless image.attributes[attribute].nil? || image.attributes[attribute] == ""
            dimage = student.download_images.create(:package_id => 253, :folder => image.folder, :url => attribute, :image_file_name => image.attributes[attribute])
          end
        end
      end

      @ids = student.download_images.pluck(:id) 
      @images = DownloadImage.where(id: @ids)
      @images.each do |image|
        if image.image_file_name.nil?
          image.update(:image_file_name => image.try(:url).downcase)
        end
        if image.year.nil?
          image.update(:year => image.folder[-4..-1])
        end

        if image.folder.include? "senior"
          for attribute in ['url', 'url1', 'url2', 'url3', 'url4']
            while @images.where(:url => attribute).count > 1
              @ids = @ids - [@images.where(:url => attribute).first.id]
              @images = DownloadImage.where(id: @ids)
            end
            unless image.image.exists?
              image.update(:image_file_name => image.image_file_name.downcase)
            end

          end
        else
          while @images.where(:folder => image.folder).where(:year => image.year).count > 1
            @ids = @ids - [@images.where(:folder => image.folder).where(:year => image.year).first.id]
            @images = DownloadImage.where(id: @ids)
          end
        end
      end
      @images = DownloadImage.find(@ids).sort_by {|x| x.year}.reverse
      
      @images.each do |image|
        unless image.image_file_name.nil? || image.image_file_name == ""
              if AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{image.image_file_name}.jpg").exists?
                  obj1 = bucket.objects["images/#{image.folder}/#{image.image_file_name}.jpg"]
                  obj2 = bucket.objects["images/watermarks/download_images/#{image.id}/original/#{image.image_file_name}.jpg"]
                  obj1.copy_to(obj2)
                  image.update(:watermark_file_name => image.image_file_name)
                  image.watermark.reprocess!
              end
          end
      end
    end
end





          
          