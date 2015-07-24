require 'uri'
require 'date'
require 'csv'
require 'insta-monitis/userinput'

module InstaMonitis
  class Backend
    include UserInput
    # Init method
    # Load all configurators then init a API object
    # Set the authToken in that API object
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

    def search_http param, style
      unless param['id'].nil?
        print(dump("testinfo&testId=#{param['id']}"), style)
      else
        unless param['tag'].nil?
          print(dump("tagtests&tag=#{param['tag']}"), style)
        else
          print(search(dump('tests')['testList'], param), style)
        end
      end
    end

    def search_http_quiet param
      unless param['id'].nil?
        return dump("testinfo&testId=#{param['id']}")
      else
        unless param['tag'].nil?
          return dump("tagtests&tag=#{param['tag']}")
        else
          return search(dump('tests')['testList'], param)
        end
      end
    end
    
    def search_fullpage param, style
      unless param['id'].nil?
        print(dump("fullPageLoadTestInfo&monitorId=#{param['id']}"), style)
      else
        print(search(dump('fullPageLoadTests'), param), style)
      end
    end

    def create_http
      this = HTTPMonitor.new
      userinput_http this
      push_test('addExternalMonitor', this)
    end

    def create_fullpage
      this = FullPageMonitor.new
      userinput_fullpage this
      push_test('addFullPageLoadMonitor', this)
    end

    def create_bulk file
      this = userinput_import file
      this.each do |test|
        case test.to_hash['type']
          when 'http'
            puts "Creating: #{test.to_post}"
            push_test('addExternalMonitor', test)
          when 'fullpage'
            puts "Creating: #{test.to_post}" 
            push_test('addFullPageLoadMonitor', test)
          else
            puts "\nMissing type of test, or bad value. Must be http or fullpage. #{test.to_hash}"
        end
      end
    end
    
    def delete_http id
      push("deleteExternalMonitor&testIds=#{id}")
    end
    
    def delete_fullpage id
      push("deleteFullPageLoadMonitor&monitorId=#{id}")
    end

    def report_http id, dayrange
      # Grab URL for that HTTP Monitor
      param = Hash.new
      param['id'] = id
      reporturl = search_http_quiet(param)['url'] 
      
      # Get the dates in order
      from = Date.today
      to = ( from - dayrange )
      
      # Place to put data
      storage = Array.new

      from.downto(to){ |date|
        puts "Issuing API requests for #{date}.."
        pull_http_results(id, date).each do |location|
          location['data'].each do |data|
            temp = Array.new
            temp << reporturl
            temp << location['locationName']
            temp << data
            storage << temp.flatten!
          end
        end 
      }
      write_csv(( storage.sort_by { |data| data[2] } ), reporturl)
    end
   
    private

    def write_csv array, url
      file = ENV['HOME'] + "/monitis-report-#{url}-" + Date.today.to_s + ".csv"
      CSV.open(file, "wb") do |csv|
        csv << [ "URL", "LOCATION", "DATE", "TIME",  "HTTP" ]
        array.each do |data|
          csv << data
        end
      end
    end

    def construct_result_action id, date
      return "testresult&testId=#{id}&year=#{date.year}&month=#{date.month}&day=#{date.day}"
    end 

    def pull_http_results id, date
      begin
        return @monitis.get(construct_result_action(id, date))
      rescue
        puts "API failure? You're not supposed to be here. Exiting."
        exit
      end
    end

    def dump action
      begin  
        return @monitis.get(action.to_s)
      rescue
          puts "API failure? You're not supposed to be here. Exiting."
          exit
      end
    end

    def search tests, param
      storage = Array.new
      tests.each do |test|
        if test["#{param.keys.first}"].eql? param.values.first or test["#{param.keys.first}"].include? param.values.first
          storage << test
        end
      end
      return storage
    end

    def push_test action, object
      @monitis.put_test(action.to_s, object) 
    end

    def push action
      @monitis.put(action.to_s)
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

