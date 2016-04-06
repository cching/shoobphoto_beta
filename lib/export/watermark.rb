module Paperclip
  class Watermark < Processor

    attr_accessor :current_geometry, :target_geometry, :format, :whiny, :convert_options, :watermark_path, :overlay, :position

    def initialize file, options = {}, attachment = nil
       super
       geometry          = options[:geometry]
       @file             = file
       @crop             = geometry[-1,1] == '#'
       @target_geometry  = Geometry.parse geometry
       @current_geometry = Geometry.from_file @file
       @convert_options  = options[:convert_options]
       @whiny            = options[:whiny].nil? ? true : options[:whiny]
       @format           = options[:format]
       @watermark_path   = options[:watermark_path]
       @position         = options[:position].nil? ? "SouthEast" : options[:position]
       @overlay          = options[:overlay].nil? ? true : false
       @current_format   = File.extname(@file.path)
       @basename         = File.basename(@file.path, @current_format)
     end

      def crop?
        @crop
      end

      def convert_options?
        not @convert_options.blank?
      end

      def make
        dst = Tempfile.new([@basename, @format].compact.join("."))
        dst.binmode

        if watermark_path
          command = "composite"
          params = "-gravity #{@position} #{watermark_path} #{fromfile} #{transformation_command} #{tofile(dst)}"
        else
          command = "convert"
          params = "#{fromfile} #{transformation_command} #{tofile(dst)}"
        end

        begin
          success = Paperclip.run(command, params)
        rescue PaperclipCommandLineError
          raise PaperclipError, "There was an error processing the watermark for #{@basename}" if @whiny
        end

        dst
      end

      def fromfile
        "\"#{ File.expand_path(@file.path) }[0]\""
      end

      def tofile(destination)
        "\"#{ File.expand_path(destination.path) }[0]\""
      end    

      def transformation_command
        scale, crop = @current_geometry.transformation_to(@target_geometry, crop?)
        trans = "-resize \"#{scale}\""
        trans << " -crop \"#{crop}\" +repage" if crop
        trans << " #{convert_options}" if convert_options?
        trans
      end

  end

end