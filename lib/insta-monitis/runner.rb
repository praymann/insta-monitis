require 'rubygems'
require 'thor'

module InstaMonitis
  class Runner < Thor    
    class_option :verbose, :type => :boolean
    
    desc "pull [IDENTIFIER] [STYLE]", "Pull test that matches/contains/is; output in json, hash, yaml"
    def pull(identifier, style)
      identifier.chomp
      style.chomp
      this = Backend.new
      log("Requesting test(s) that matches/contains/is: #{identifier}")
      log("Requesting test(s) in json format\n\n")
      this.search(identifier, check_style(style))
    end
    
    desc "pullall [STYLE]", "Pull down ALL tests; output in json, hash, yaml"
    def pullall(style)
      style.chomp
      this = Backend.new
      log("WARNING: This may take a while!")
      log("Requesting all tests in #{style} format\n\n")
      this.dump(check_style(style))
    end
    
    desc "add [WEBSITE]", "Add defined default tests for WEBSITE"
    def add(website)
        this = Backend.new
        log("API - Add tests for #{website}")
        #this.create(website)
    end
    
    no_commands do
      def log(str)
        puts str if options[:verbose]
      end
    end

    private
    
    def check_style string
      case string
        when 'yaml'
          return string 
        when 'json'
          return string
        when 'hash'
          return string
        else
          puts "I don't recongize that style of data..."
          exit
      end
    end

  end
end
