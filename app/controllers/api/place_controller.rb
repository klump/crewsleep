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
    place = Sleep::Place.find(params[:id])
    section = Sleep::Section.first(:conditions => { "rows._id" => place.row_id })
    row = section.rows.find(place.row_id)

    render :json => {
        :name => section.name+" "+row.index.to_s+"-"+place.index.to_s,
        :valid_minutes => section.valid_minutes
    }.to_json
  end

end