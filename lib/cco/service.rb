require 'net/http'
require 'net/https'
require 'uri'

module Cco

end
class Cco::Service

  def self.fetch_person(id_or_nick)
    uri = URI.parse("https://crew.dreamhack.se/export/user?zion=raw&user="+id_or_nick.to_s)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth("ssv", "vss")
    response = http.request(request)
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