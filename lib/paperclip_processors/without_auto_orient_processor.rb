module Paperclip
  class WithouAutoOrientProcessor < Paperclip::Thumbnail
    def initialize(file, options = {}, attachment = nil)
      options[:auto_orient] = false
      super
    end
  end
end