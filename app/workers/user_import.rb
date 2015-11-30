class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)

      	chunk.each do |h|
    f = Field.create(:id => h[:id], :x => h[:x], :y => h[:y], :width => h[:width], :height => [:height], :align => "#{h[:align]}", :column => "#{h[:column]}", :template_id => h[:template_id], :font_id => h[:font_id], :text_size => h[:text_size], :color => "#{h[:color]}", :spacing => h[:spacing], :name => "#{h[:name]}", :created_at => "#{h[:created_at]}", :updated_at => "#{h[:updated_at]}")
    f.errors.full_messages.each do |error|
    	puts "#@@@@@@#{error}"
    end
  end
 	end
end

