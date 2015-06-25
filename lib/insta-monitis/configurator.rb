require 'yaml'

module InstaMonitis
  class Configurator

    @@file = ENV['HOME'] + '/.monitis'

    def self.load opts={}
      if opts.class == String
        opts = { "file" => opts }
      end

      file = opts.delete("file") || opts.delete(:file) || @@file
      conf = YAML.load_file(file)

      # overide config with passed options
      opts.each do |key, val|
        conf[key] = val
      end

      return conf
    end
  end
end
