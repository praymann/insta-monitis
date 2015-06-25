require 'yaml'

module InstaMonitis
  class Configurator

    @@file = ENV['HOME'] + '/.monitis'

    @@defaults = ENV['HOME'] + '/.monitis_defaults'

    def self.load 
      opts = {}
      if File.exist? @@file
        file = YAML.load_file(@@file)
        
        opts.each do |key, val|
          file[key] = val
        end    
        
        return file unless File.exist? @@defaults

        defaults = YAML.load_file(@@defaults)

        file["defaults"] = defaults
        
        return file
      end
    end
  end
end
