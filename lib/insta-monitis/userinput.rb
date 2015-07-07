require 'csv'

module InstaMonitis
  module UserInput 
    @@input = [ 'name', 'url', 'tag', 'loc' ]

    def userinput_http test
      @@input.each do | input |
        test.send "set_#{input}", ( send "get_#{input}" )
      end
    end
    
    def userinput_fullpage test
      @@input.each do | input |
        test.send "set_#{input}", ( send "get_#{input}" )
      end
      test.set_chk get_chkint test
    end
  
    def userinput_import file
      array = []
      errors = []
      puts "File valid. Importing.\n" 
      CSV.foreach(file.to_s, :headers => true, :skip_blanks => true) do |row|
        if row['type'] == 'http'
          begin
            array << cast_to_http(row)
          rescue
            errors << $INPUT_LINE_NUMBER.to_s
          end
        elsif row['type'] == 'fullpage' 
          begin
            array << cast_to_fullpage(row) 
          rescue => e
            puts e.message
            errors << $INPUT_LINE_NUMBER.to_s
          end
        else
          errors << $INPUT_LINE_NUMBER.to_s
        end
      end

      if errors.empty?
        return array
      else
        errors.each do |line|
          puts "\tRow ##{line} can't be cast into HTTPMonitor or FullPageMonitor"
        end
        puts "\nFix or remove the above row(s) to proceed\n"
        exit
      end
    end

    private
    
    def get_name
      puts "Enter name:"
      name = STDIN.gets
      return name.chomp!
    end

    def get_tag
      puts "Tag:"
      tag = STDIN.gets
      return tag.chomp!
    end

    def get_url
      puts "URL:"
      url = STDIN.gets
      if url.include?('http:') || url.include?('https:')
        puts "URL can't contain http://\n"
        get_url
      else
        return url.chomp!
      end
    end

    def get_loc
      puts "1=MID,9=EST,10=WST,26=NY,27=LV"
      puts "Locations:"
      return STDIN.gets.chomp!.split(" ").map(&:to_i)
    end
    
    def get_chkint test
      puts "Check interval:"
      return STDIN.gets.chomp!.split(" ").map(&:to_i)
    end

    def cast_to_http row 
      this = HTTPMonitor.new
      this.from_hash! row.to_hash
      this.set_loc row.to_hash["locationIds"].split(' ')
      return this
    end

    def cast_to_fullpage row
      this = FullPageMonitor.new
      this.from_hash! row.to_hash
      this.set_loc row.to_hash["locationIds"].split(' ')
      this.set_chk row.to_hash["checkInterval"].split(' ')
      return this
    end
  end
end
