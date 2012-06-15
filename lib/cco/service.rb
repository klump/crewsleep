require 'net/http'
require 'net/https'
require 'uri'

module Cco
  class Service

    def self.fetch_person(id_or_nick)
      uri = URI("https://crew.dreamhack.se/export/user?zion=raw&user="+id_or_nick.to_s)
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth("ssv", "vss")
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
        https.request(request)
      end
      response_object = PHP.unserialize(response.body)

      return nil if response_object == false

      if (response_object.kind_of?(Array)) then
      return nil if response_object.empty?
        person_hash = response_object[0]
      else
      person_hash = response_object
      end

      avatar_url = person_hash.has_key?("img") ? person_hash["img"] : nil

    person = Crew::Person.create(
      :username => person_hash["username"],
      :firstname => person_hash["firstname"],
      :lastname => person_hash["lastname"],
      :cco_id => person_hash["uid"],
      :avatar_url => avatar_url
    )

    return person
    end

  end
end