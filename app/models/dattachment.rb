class Dattachment < ActiveRecord::Base
    belongs_to :dproject

        # This method associates the attribute ":avatar" with a file attachment
        has_attached_file :sfile

end
