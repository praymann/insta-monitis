require 'rubygems'
require 'thor'

module InstaMonitis

  module RunnerHelper
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

    def check_options options
      storage = options.reject { |k, v| k == 'verbose' }
      storage.reject! { |k, v| k == 'style' }
      if storage.length < 1 or storage.length > 1
        puts "Too few or too many options, one at a time please."
        exit
      else
        return storage
      end
    end

    def require_id options
      storage = options.reject { |k, v| k == 'verbose' }
      storage.reject! { |k, v| k == 'style' }
      if storage[:id].nil? 
        puts "Generating a report requires a test id."
        exit
      else
        return storage
      end
    end

    def check_file file
      if File.exist? file
        if file.include? '.csv'
          return file
        else
          puts "File must end with .csv"
          exit
        end
      else
        puts "Is that a valid filename or valid path?"
        exit
      end
    end
  end

  class List < Thor
    include RunnerHelper
    
    class_option :style, :aliases => '-s', :default => 'yaml', :desc => 'Style of output, yaml:json:hash'
   
    desc "http --style=[STYLE]", "List all http tests"
    long_desc <<-LONGDESC
      Using the API, list all External Monitors of type http.
    LONGDESC
    def http()
      this = Backend.new
      log("Requesting all http tests in #{options[:style]} format\n\n")
      this.dump_http(check_style(options[:style]))
    end

    desc "page --style=[STYLE]", "List all full page load tests"
    long_desc <<-LONGDESC
      Using the API, list all Full Page Load Monitors of type fullpageload.
    LONGDESC
    def page()
      this = Backend.new
      log("Requesting all fullpageload tests in #{options[:style]} format\n\n")
      this.dump_fullpage(check_style(options[:style]))
    end

    desc "all --style=[STYLE]", "List all tests, sorted by id"
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
  end


  class Add < Thor
    include RunnerHelper
  
    desc "http", "Interactively create a http test"
    long_desc <<-LONGDESC
      After building a local http ExternalMonitor, use the API to created it in Monitis.
    LONGDESC
    def http()
      Backend.new.create_http
    end
    
    desc "page", "Interactively create a full page load test"
    long_desc <<-LONGDESC
      After building a local FullPageLoad Monitor, use the API to created it in Monitis.
    LONGDESC
    def page()
      Backend.new.create_fullpage
    end
    
    desc "bulk --file=[FILE]", "Via file, create one or many test(s)"
    long_desc <<-LONGDESC
      Load in a file full of test(s), use the API to created them in Monitis.
    LONGDESC
    option :file, :aliases => '-f', :desc => 'Filename to load'
    def bulk()
      Backend.new.create_bulk(check_file(options[:file]))
    end


    no_commands do
      def log(str)
        puts str if options[:verbose]
      end
    end
  end

  class Del < Thor
    class_option :id, :aliases => '-i', :type => :numeric, :desc => 'Id of test'
    desc "http --id=[N]", "Delete the http test with given Id"
    long_desc <<-LONGDESC
      There is no undo, given an Id go nuclear and nuke it from orbit. 
    LONGDESC
    def http()
      Backend.new.delete_http(options[:id])
    end

    desc "page --id=[N]", "Delete the full page load test with given Id"
    long_desc <<-LONGDESC
      There is no undo, given an Id go nuclear and nuke it from orbit. 
    LONGDESC
    def page()
      Backend.new.delete_fullpage(options[:id])
    end

  end

  class Search < Thor
    include RunnerHelper
    class_option :style, :aliases => '-s', :default => 'yaml', :desc => 'Style of output, yaml:json:hash'
    class_option :id, :aliases => '-i', :type => :numeric, :desc => 'Id of test'
    class_option :name, :aliases => '-n', :desc => 'Name of test'
    class_option :url, :aliases => '-u', :desc => 'URL of test'
    class_option :tag, :aliases => '-t', :desc => 'Tag of test(s)'

    desc "http --[OPTION]=[VALUE] --style=[STYLE]", "Search all http tests"
    long_desc <<-LONGDESC
      Using the API, search through all External Monitors of type http.
      
      For a given id ( -i, --id ) find the matching monitor
      
      For a given name ( -n, --name ) find the matching monitor
      
      For a given string ( -u, --url ) find any monitor which has a URL value that contains string
      
      For a given tag ( -t, --tag ) find any montior with a matching tag
    LONGDESC
    def http()
      this = Backend.new
      this.search_http(check_options(options), check_style(options[:style]))
    end

    desc "page --[OPTION]=[VALUE] --style=[STYLE]", "Search all fullpage tests"
    long_desc <<-LONGDESC
    
    LONGDESC
    def page()
      this = Backend.new
      this.search_fullpage(check_options(options), check_style(options[:style]))
    end

    no_commands do
      def log(str)
        puts str if options[:verbose]
      end
    end
  end

  class Report < Thor
    include RunnerHelper
    class_option :id, :aliases => '-i', :type => :numeric, :desc => 'Id of test'
    class_option :days, :aliases => '-d', :type => :numeric, :desc => 'How many days', :default => 150
    desc "http --[ID]=[N] --[DAYS]=[N]", "Generate report for given http test"
    long_desc <<-LONGDESC
      Using the API, generate a .csv report of a HTTP Monitor going back [x] days.
      
      For a given id ( -i, --id ), use the api to pull every day going back to [x] days.

      If the amount of days ( -d, --days ), isn't set, it will default to 150 days.

      Combine the results sanely, and dump it into a .csv file.
    LONGDESC
    def http()
      this = Backend.new
      this.report_http(require_id(options)[:id], options[:days]) 
    end
  end

  class Runner < Thor
    class_option :verbose, :aliases => '-v', :type => :boolean

    desc "list [COMMAND] [ARGS]", "Perform list operations" 
    subcommand "list", List
  
    desc "add [COMMAND] [ARGS]", "Perform add operations"
    subcommand "add", Add

    desc "del [COMMAND] [ARGS]", "Perform delete operations"
    subcommand "del", Del

    desc "search [COMMAND] [ARGS]", "Perform search operations"
    subcommand "search", Search

    desc "report [COMMAND] [ARGS]", "Perform report operations"
    subcommand "report", Report

    no_commands do
      def log(str)
        puts str if options[:verbose]
      end
    end
  end
end
