class ItemsExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      School.all.each do |school|
        school.students.each do |student|
          if student.student_images.where("lower(folder) like ?", "%fall2017%").any?
            student.update(:enrolled => true)
          end
        end
      end
    end
end