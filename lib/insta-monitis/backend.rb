require 'uri'

module InstaMonitis
  class Backend
   
    # Init method
    # Load all configurators then init a API object
    def initialize
      conf = Configurator.load()
      
      @monitis = Api.new(conf)

      @monitis.set_authtoken(@monitis.get('authToken')["authToken"])
    end

    def dump_http style
      puts "External Monitors"
      print(dump('tests')['testList'], style)
    end

    def dump_fullpage style
      puts "Full Page Monitors"
      print(dump('fullPageLoadTests'), style)
    end
    
    def dump_all style
      puts "All Monitors"
      storage = Array.new
      dump('fullPageLoadTests').each do |test|
        storage << test
      end
      dump('tests')['testList'].each do |test|
        storage << test
      end
      storage.sort_by! { |h| h['id'] }
      print(storage, style)
    end

    def search string, style
      if !/\A\d+\z/.match(string)
        # Not a positive number, url?
      else
        # Number
        send "print_#{style}", @monitis.get("testinfo&testId=#{string}")
      end
    end
   
    private

    def dump action
      begin  
        return @monitis.get(action.to_s)
      rescue
          puts "API failure? You're not supposed to be here. Exiting."
      end
    end
 
    def push_test
    
    end

    def print object, style
      object.each do |thing|
        send "print_#{style}", thing
      end
    end
    
    def print_yaml test
        puts test.to_yaml
    end
    
    def print_json test
      puts test.to_json
    end
    
    def print_hash test
      puts test.to_h
    end
  end
end
