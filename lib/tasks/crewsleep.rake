namespace :crewsleep do

  desc "Seed places from a config"
  task :seed_places, [ :config_name ] => :environment do |t, args|
    begin
      config = YAML.load_file("#{Rails.root}/config/places/#{args.config_name}.yml")
    rescue
      puts "Invalid config"
      next
    end

    if (Sleep::Section.count > 0)
      puts "Cannot continue with places already in the system. Clear the database to re-seed."
      next
    end

    config["sections"].each do |section_config|
      section = Sleep::Section.create({ :name => section_config["name"], :valid_minutes => section_config["valid_minutes"] })
      section_config["rows"].each do |row_config|
        row = section.rows.create({ :index => row_config["row"] })
        row_config["places"].times do |place_index|
          row.places.create({ :index => place_index+1 })
        end
      end
    end

    puts "Done"
  end

  desc "Set the wakeup sorting of places"
  task :sort_places => :environment do
    Sleep::Section.all.each do |section|
      row_string = ""
      section.rows.each do |row|
        row_string += "," unless row_string.empty?
        row_string += row.index.to_s
      end
      puts "Enter row groups for \"#{section.name}\" with rows: #{row_string} [e.g. 1-2,3]:"
      sorting_index = 0
      STDIN.readline.split(",").each do |row_group|
        row_ids = []
        row_group.split("-").each do |row_index|
          row_ids.append(section.rows.where(index: row_index).one._id)
        end
        Sleep::Place.where(:row_id.in => row_ids).order_by([ :index, :asc ]).each do |place|
          place.sorting_index = sorting_index
          place.save
          place.people.each do |person|
            person.alarms.each do |alarm|
              alarm.update_person_and_place
              alarm.save
            end
          end
          sorting_index += 1
        end
      end
    end
    puts "Done"
  end

end
