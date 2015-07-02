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
  end
end
