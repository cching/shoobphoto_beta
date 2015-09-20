module TTFunk
  class File
    
    # Override to accept external files.
    def self.open(file)
      if file =~ /^https?:\/\//
        new(Thread.current[:export_files][file].read)
      else
        new(::File.open(file, "rb") { |f| f.read })
      end
    end
    
  end
end

module Prawn
  class Font
    
    # Override to dump query string.
    def self.load(document,name,options={})
      case name.split('?').first
      when /\.ttf$/i   then TTF.new(document, name, options)
      when /\.dfont$/i then DFont.new(document, name, options)
      when /\.afm$/i   then AFM.new(document, name, options)
      else                  AFM.new(document, name, options)
      end
    end
    
  end
end