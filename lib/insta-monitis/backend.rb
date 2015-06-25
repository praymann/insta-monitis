require 'dish'
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
    
    def dump style
      begin
        puts "External Monitors"
        tests = @monitis.get("tests")
        tests["testList"].each do |test|
          send "print_#{style}", test
        end
        puts "Full Page Monitors"
        @monitis.get("FullPageLoadTests").each do |test|
          send "print_#{style}", test
        end
      rescue
          puts "You're not supposed to be here. Exiting."
      end
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
 
    def push_test
    
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
