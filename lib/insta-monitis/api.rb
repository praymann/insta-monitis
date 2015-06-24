require "insta-monitis/ver/version"
require 'net/http'
require 'base64'
require 'json'
require 'uri'

module InstaMonitis
    class Api 
      @@host = 'https://api.monitis.com'
      @@prefix = '/api'
      @@version = 'version=3'

      def initialize opts={}
        @key    = opts["key"]
        @secret = opts["secret"]
      end

      def construct_authstring
        unless defined?(@key).nil? and defined?(@secret).nil?
          return "apikey=#{@key}&secretkey=#{@secret}"
        end
      end

      def construct_apiuri endpoint
        begin
          auth_string = construct_authstring
          return URI("#{@@host}#{@@prefix}?action=#{endpoint}&#{auth_string}&#{@@version}")
        rescue URI::InvalidURIError
          puts "URI build failed. Is this a valid URI format?: #{@@host}#{@@prefix}?action=#{endpoint}&#{auth_string}&#{@@version}"
          exit
        end
      end
      
      def construct_httpuri
        return URI("#{@@host}")
      end
      
      def get endpoint

        # remove preceeding slash
        endpoint.gsub!(/^\//, '')

        uri  = construct_apiuri(endpoint)
        
        http = Net::HTTP.new(uri.host, uri.port)

        http.use_ssl = true
        
        begin
          res = http.get(uri.path + '?' + uri.query)
          return JSON.parse(res.body) unless res.code == '403'
            puts "HTTP 403 received: #{res.body}"
            exit
        rescue TypeError
          puts "Empty JSON Response from Monitis? Can't convert nil to String"
        rescue Timeout::Error => e
          puts "Possible HTTP Timeout issue"
        rescue 
          
        end
      end
    end
end
