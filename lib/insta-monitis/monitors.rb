module InstaMonitis
  class HTTPMonitor
    def initialize
      @type = 'http'
      @name = nil
      @url = nil
      @interval = 1
      @timeout = 30
      @locationIds = nil
      @tag = nil
    end 

    def set_name string
      @name = string
    end

    def set_url string
      @url = string
    end
    
    def set_loc array
      @locationIds = array.join(", ")
    end
    
    def set_tag string
      @tag = string
    end
    
    def to_json
      hash = {}
      self.instance_variables.each do |k|
        hash[k] = self.instance_variable_get k
      end
      hash.to_json
    end
    
    def from_json! string
      JSON.load(string).each do |k, v|
        self.instance_variable_set "@#{k}", v
      end
    end

    def from_hash! hash
      hash.each do |k,v|
        self.instance_variable_set "@#{k}", v
      end
    end

    def to_post
      string = ""
      self.instance_variables.each do |k|
        string << "&#{k}=#{(self.instance_variable_get k).to_s.delete(' ')}"
      end
      return string
    end
  end

  class FullPageMonitor
    def initialize
      @name = nil
      @url = nil
      @interval = 1
      @timeout = 59000
      @locationIds = nil
      @checkInterval = nil
      @tag = nil
    end

    def set_name string
      @name = string
    end

    def set_url string
      @url = string
    end
    
    def set_loc array
      @locationIds = array.join(", ")
    end

    def set_chk array
      @checkInterval = array.join(", ")
    end
    
    def set_tag string
      @tag = string
    end

    def to_json
      hash = {}
      self.instance_variables.each do |k|
        hash[k] = self.instance_variable_get k
      end
      hash.to_json
    end
    
    def from_json! string
      JSON.load(string).each do |k, v|
        self.instance_variable_set "@#{k}", v
      end
    end

    def from_hash! hash
      hash.each do |k,v|
        self.instance_variable_set "@#{k}", v
      end
    end

    def to_post
      string = ""
      self.instance_variables.each do |k|
        string << "&#{k}=#{(self.instance_variable_get k).to_s.delete(' ')}"
      end
      return string
    end
  end
end
