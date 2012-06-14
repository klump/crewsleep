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

end
