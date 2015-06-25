require 'rubygems'
require 'thor'

module InstaMonitis

  class List < Thor
    class_option :style, :default => 'yaml', :desc => 'Style of output, yaml:json:hash'
   
    desc "list http --style=[STYLE]", "List all http tests"
    long_desc <<-LONGDESC
      Using the API, list all External Monitors of type http.
    LONGDESC
    def http()
      this = Backend.new
      log("Requesting all http tests in #{options[:style]} format\n\n")
      this.dump_http(check_style(options[:style]))
    end

    desc "list page --style=[STYLE]", "List all full page load tests"
    long_desc <<-LONGDESC
      Using the API, list all Full Page Load Monitors of type fullpageload.
    LONGDESC
    def page()
      this = Backend.new
      log("Requesting all fullpageload tests in #{options[:style]} format\n\n")
      this.dump_fullpage(check_style(options[:style]))
    end

    desc "list all --style=[STYLE]", "List all tests, sorted by id"
    long_desc <<-LONGDESC
      Using the API, list every single monitor of any type. Sorted by id
    LONGDESC
    def all()
      this = Backend.new
      log("Requesting everything single test in #{options[:style]} format\n\n")
      this.dump_all(check_style(options[:style]))
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
          puts "Valid options are json, hash, yaml. Default style is YAML"
          exit
      end
    end
  end


  class Add < Thor
    #def add(website)
      #this = Backend.new
      #log("API - Add tests for #{website}")
      #this.create(website)
    #end
  end

  class Search < Thor

  end

  class Runner < Thor
    class_option :verbose, :type => :boolean

    desc "list <subcommand> <args>", "Perform list operations" 
    subcommand "list", List
  
    desc "add <subcommand> <args>", "Perform add operations"
    subcommand "add", Add

    desc "search <subcommand> <args>", "Perform search operations"
    subcommand "search", Search

    no_commands do
      def log(str)
        puts str if options[:verbose]
      end
    end
  end
end
