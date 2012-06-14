class Api::PlaceController < ApplicationController

  def index
    render :json => Sleep::Section.all.order_by([:name, :asc]).to_json(
      :include => {
        :rows => {
          :include => {
            :places => {
              :exclude => [ :created_at, :update_at ]
            }
          },
          :exclude => [ :created_at, :updated_at ]
        }
      },
      :exclude => [ :created_at, :updated_at ]
    )
  end

  def show
    place = Sleep::Place.find(params[:place])
    section = Sleep::Section.first(:conditions => { "rows._id" => place.row_id })
    row = section.rows.find(place.row_id)

    render :json => {
        :name => section.name+" "+row.index.to_s+"-"+place.index.to_s,
        :valid_minutes => section.valid_minutes
    }.to_json
  end

  def replace_all
    Sleep::Section.delete_all

    params[:places].each_value do |section_data|
      valid_minutes = Array.new
      puts section_data
      section_data["valid_minutes"].split(",").each do |part|
        valid_minutes.push(part.to_i)
      end
      section = Sleep::Section.create({ :name => section_data["name"], :valid_minutes => valid_minutes })

      row_index = 1
      section_data["rows"].each_value do |row_data|
        row = section.rows.create({ :index => row_index })
        row_index += 1

        place_count = 1
        row_data.to_i.times do
          row.places.create({ :index => place_count })
          place_count += 1
        end
      end
    end

    render :nothing => true
  end

end