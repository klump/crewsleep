# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


#This is the setup for DreamHack Winter 2011

Sleep::Section.delete_all
Sleep::Alarm.delete_all
Sleep::Place.delete_all
Crew::Person.delete_all

main = Sleep::Section.create(:name=>"Main", :valid_minutes=>[0,30])
main.gen_row(1, 1..46)
main.gen_row(2, 1..45)
main.gen_row(3, 1..45)
main.gen_row(4, 1..45)
main.gen_row(5, 1..44)
main.gen_row(6, 1..39)


snark = Sleep::Section.create(:name=>'Snarken', :valid_minutes=>[0,30])
snark.gen_row(1, 1..11)
snark.gen_row(2, 1..11)
snark.gen_row(3, 1..11)
snark.gen_row(4, 1..11)
snark.gen_row(5, 1..11)
snark.gen_row(6, 1..3)
snark.gen_row(7, 1..9)
snark.gen_row(8, 1..10)

#testdata
if Rails.env == "development"
  def random_place
    s = Sleep::Section.all.to_a[rand(2)]
    r = s.rows[rand(s.rows.length)]
    r.places[rand(r.places.length)]
  end
  def random_name
    (0..10).map{(rand('z'.ord-'a'.ord) + 'a'.ord).chr}.join("")
  end
  
  10.times do
    pl = Sleep::Section.all.to_a[rand(2)].rows
    Crew::Person.create(:firstname=>random_name, :username=>random_name, :place => random_place)
  end
  persons = Crew::Person.all.to_a
  100.times do
    Sleep::Alarm.create({ :person => persons[rand(persons.length)], :time => Time.now + (rand(12)*3).hours })
  end
end
