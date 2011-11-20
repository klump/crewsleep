module Crew::PersonHelper

  def self.fetch_person_by_cco_id(cco_id)
    person = Crew::Person.first(:conditions => { :cco_id => cco_id })
    return person if !person.nil?
    person = Crew::CcoService.fetch_person(cco_id)
    return person
  end

  def self.fetch_person_by_username(username)
    person = Crew::Person.first(:conditions => { :username => /#{username}/i })
    return person if !person.nil?
    person = Crew::CcoService.fetch_person(username)
    return person
  end

end