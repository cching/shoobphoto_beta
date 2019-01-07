class Dattachment < ActiveRecord::Base
    belongs_to :dproject

    has_attached_file :afile,
    :url => ':s3_domain_url',
    :path => '/images/projects/:id/:updated_at/:filename'
    do_not_validate_attachment_file_type :afile

end
