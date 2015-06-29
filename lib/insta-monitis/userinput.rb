module InstaMonitis
  module UserInput 
    def userinput_http test
      test.set_name get_name.to_s
      test.set_tag get_tag.to_s
      test.set_loc get_loc
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
      return url.chomp!
    end

    def get_loc
      puts "1=MID,9=EST,10=WST,26=NY,27=LV"
      puts "Locations:"
      locations = STDIN.gets
      return locations.chomp!.split(" ").map(&:to_i)
    end
  end
end
