require 'yaml'

module InstaMonitis
  class Configurator

    @@file = ENV['HOME'] + '/.monitis'

    def self.load 
      opts = {}
      if File.exist? @@file
        file = YAML.load_file(@@file)
        
        opts.each do |key, val|
          file[key] = val
        end    
        
        return file
      end
    end
  end
end
