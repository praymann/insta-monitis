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

      def api_uri endpoint
        begin
          return URI("#{@@host}#{@@prefix}?#{endpoint}&#{@@version}")
        rescue URI::InvalidURIError
          puts "URI build failed. Is this a valid URI format?: #{@@host}#{@@prefix}?#{endpoint}&#{@@version}/#{endpoint}"
          exit
        end
      end

      def token_uri
        return URI("#{@@host}#{@@prefix}/token")
      end
      
      def http_uri
        return URI("#{@@host}")
      end
      
      def post_data
        opts = {
          :grant_type    => 'client_credentials',
          :client_id     => @key,
          :client_secret => @secret
        }
        return URI.encode_www_form(opts)
      end

      def fetch_token
        uri = token_uri
        
        http = Net::HTTP.new(uri.host, uri.port)
        
        http.use_ssl = true
        
        res    = http.post(uri.path, post_data)
        
        @token = JSON.parse(res.body)["access_token"]
      end

      def headers
        return {
          "Authorization" => "Bearer #{Base64.urlsafe_encode64(@token)}"
        }
      end

      def get endpoint

        # remove preceeding slash
        endpoint.gsub!(/^\//, '')

        fetch_token
        
        uri  = api_uri(endpoint)
        
        http = Net::HTTP.new(uri.host, uri.port)

        http.use_ssl = true
        
        begin
          res = http.get(uri.path, headers)
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
      
      def put endpoint
      
        # remove preceeding slash
        endpoint.gsub!(/^\//, '')
        
        fetch_token

        uri  = api_uri(endpoint)

        http = Net::HTTP.new(uri.host, uri.port)

        http.use_ssl = true
        
        begin
        
          res = http.post(uri.path, post_data)
          
        rescue TypeError
          puts "Empty JSON Response from Catchpoint? Can't convert nil to String"
        rescue Timeout::Error => e
          puts "Possible HTTP Timeout issue"
        end
      end
    end
end
