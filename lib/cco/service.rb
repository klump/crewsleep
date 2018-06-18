require 'net/http'
require 'net/https'
require 'uri'
require 'yaml'
require 'json'

module Cco
  class Service

    class NoCcoCredentials < StandardError
    end

    def self.fetch_person(id_or_nick)
      # We need a username or id to lookup something in the API
      return nil if id_or_nil.nil? or id_or_nick.empty?

      # Get CCO credentials from config/cco.yml
      cco_config = YAML.load_file('config/cco.yml')

      unless cco_config['api_url'] and cco_config['user'] and cco_config['password']
        Rails.logger.err("Problems with CCO configuration: Please doublecheck the CCO related settings in `config/cco.yml`.")
        return nil
      end

      # Remove trailing slash from API url if there is any
      cco_config['api_url'].gsub!(/\/$/, '')

      uri = URI("#{cco_config['api_url']}/1/user/get/#{URI.encode(id_or_nick.to_s)}")
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(cco_config['user'], cco_config['password'])
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |https|
        https.request(request)
      end

      response_object = nil
      case response
      when Net::HTTPSuccess then
        begin
          response_object = JSON.parse(response.body)
        rescue
          Rails.logger.err("Could not parse reply from CCO as JSON: #{response.body}")
          return nil
        end
      else
        Rails.logger.err("CCO server replied with error: #{response.code} #{response.message}")
        return nil
      end

      if response_object
        if response_object['error']
          Rails.logger.err("CCO API replied with error: #{response_object['error']}")
          return nil
        else
          # Happy path: everything went alright

          person = Crew::Person.create(
            :username   => response_object['username'],
            :firstname  => response_object['firstname'],
            :lastname   => response_object['lastname'],
            :cco_id     => response_object['uid'],
            :avatar_url => response_object['img'],
          )

          return person
        end
      else
        Rails.logger.err("No reply and no error message from CCO server.")
        return nil
      end
    end

  end
end
