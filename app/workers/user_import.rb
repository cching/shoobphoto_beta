class UserImport
 	include Sidekiq::Worker
 	sidekiq_options queue: "package_import"

  	def perform(chunk)

      	chunk.each do |h|
    f = Field.create(:id => h[:id].to_i, :x => h[:x].to_i, :y => h[:y].to_i, :width => h[:width].to_i, :height => [:height].to_i, :align => "#{h[:align]}", :column => "#{h[:column]}", :template_id => h[:template_id], :font_id => h[:font_id], :text_size => h[:text_size], :color => "#{h[:color]}", :spacing => h[:spacing], :name => "#{h[:name]}", :created_at => "#{h[:created_at]}", :updated_at => "#{h[:updated_at]}")
    f.errors.full_messages.each do |error|
    	puts "#@@@@@@#{error}"
    end
  end
 	end
end

