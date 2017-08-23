module Paperclip
  class NoRotation < Processor
    def make
      command = "jhead"
      params = %W[-norot #{abs_path_to_file(@file)}]

      begin
        Paperclip.run(command, params.join(' '))
      rescue ArgumentError, Cocaine::CommandLineError
        raise Paperclip::Error, "There was an error removing rotation for #{@basename}"
      end

      @file
    end

    def abs_path_to_file(destination)
      File.expand_path(destination.path)
    end
  end
end