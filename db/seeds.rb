# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


#This is the setup for DreamHack Winter 2011

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