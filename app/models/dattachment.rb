class Dattachment < ActiveRecord::Base
	belongs_to :dproject

		has_attached_file :project_attachment,
  	:url => ':s3_domain_url',
  	:path => '/images/projects/:id/:filename'
  	do_not_validate_attachment_file_type :project_attachment
end
