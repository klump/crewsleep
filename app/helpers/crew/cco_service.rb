require 'net/http'
require 'net/https'
require 'uri'

class Crew::CcoService

  def self.fetch_person(id_or_nick)
    uri = URI.parse("https://crew.dreamhack.se/export/user?zion=raw&user="+id_or_nick)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth("ssv", "vss")
    response = http.request(request)
    #puts response.body
    response_object = PHP.unserialize(response.body)

    if (!response_object.empty?) then
      person_hash = response_object[0]

      person = Crew::Person.create(
          :username => person_hash["username"],
          :firstname => person_hash["firstname"],
          :lastname => person_hash["lastname"],
          :cco_id => person_hash["uid"],
          :avatar_url => "http://crew.dreamhack.se"+person_hash["img"]
      )

      return person
    end

    return nil
  end

end