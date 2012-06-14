class Api::PersonController < ApplicationController

  def fetch
    person = Crew::Person.by_username_or_cco_id(params[:q])
    render :json => person.to_json(
        :except => [ :created_at, :updated_at ],
        :include => [ :place, :alarms ]
    )
  end

  def book
    person = Crew::Person.find(params[:id])
    place = Sleep::Section.find(params[:section]).rows.find(params[:row]).places.find(params[:place])
    person.place = place
    person.save

    render :nothing => true
  end

end