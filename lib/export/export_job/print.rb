class ExportJob
  
  class Print
    
    def initialize export_data, path, package_id
      @export_data, @path = export_data, path
      @package = Package.find(package_id)
    end
    
    def generate
      require 'prawn'
      
      pdf = Prawn::Document.new(skip_page_creation: true)
      
      begin
        # Pre-fetch all fonts, pdfs, and images.
        fetch_files

        # Register fonts.
        @export_data.template.fonts.each do |font|
          pdf.font_families.update(font.name => {
            normal: font.file.url
          })
        end

        # Cache pdf.
        @pdf = Thread.current[:export_files][@export_data.pdf.file.url]

        @export_data.students.each do |student|

     


          pdf.start_new_page template: @pdf, margin: 0

          @export_data.template.fields.each do |field|

            # Handle image inserts.
            if ExportJob.image_columns.include? field.column
              if url = student.student_images.where(:package_id => @package.id).last.image.url
                pdf.image open(Thread.current[:export_files][url]),
                  at: [field.x, field.y],
                  width: field.width,
                  height: field.height
              end

            # Handle colors.
            elsif ExportJob.color_columns.include? field.column
              pdf.fill_color student.send(field.column)
              pdf.fill_rectangle [field.x, field.y], field.width, field.height

            # Handle text inserts.
            else

              text = if field.column == 'prompt'
                @export_data.prompt_values[field.name] || ""
              elsif field.column == 'type'
                @export_data.type.name
              else
                student.send(field.column)
              end

              pdf.font field.font.name
              #pdf.fill_color field.color
              pdf.text_box "#{text}", at: [field.x, field.y], width: field.width,
                height: field.height, align: field.align.to_sym, size: field.text_size,
                overflow: :shrink_to_fit, character_spacing: field.spacing
            end

          end

        end


      ensure
        dump_files
      end
      
      pdf.render_file @path
      
    end
    
    # Pre-fetch all files associated with this export in parallel. A block is
    # provided to the hash so key lookup only depends on the path of the url.
    def fetch_files
      require 'open-uri'
      Thread.current[:export_files] = Hash.new do |hash, key|
        hash[key] = hash.has_key?(path = URI(key).path) ? hash[path] : nil
      end
      file_urls.each_with_object(Thread.current[:export_files]).map do |url, hash|
        hash[URI(url).path] = open(url)
      end
    end

    # After the export is done with all the files, empty the thread variable.
    def dump_files
      Thread.current[:export_files] = nil
    end

    # The urls of each file associated with this export.
    def file_urls
      urls = { @export_data.pdf.file.url => true }
      @export_data.template.fonts.map { |font| urls[font.file.url] = true }
      if @export_data.columns.include? 'image'
        @export_data.students.map { |student| urls[student.student_images.where(:package_id => @package.id).last.image.url] = true }
      elsif @export_data.columns.include? 'image_if_present'
        @export_data.students.map do |student|
          if student.student_images.where(:package_id => @package.id).last.image?
            urls[student.student_images.where(:package_id => @package.id).last.image.url] = true
          end
        end
      end
      urls.keys
    end
    
  end
  
end