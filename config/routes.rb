Crewsleep::Application.routes.draw do

  scope :module => "api" do
    post "api/v1/book_place" => "person#book"

    get "api/v1/fetch_place_info" => "place#show"
    get "api/v1/fetch_places" => "place#index"
    post "api/v1/save_places" => "place#replace_all"

    get "api/v1/fetch_person" => "person#show"

    get "api/v1/fetch_active_alarms" => "alarm#index_active"

    post "api/v1/set_alarm" => "alarm#create"
    post "api/v1/delete_alarm" => "alarm#destroy"
    post "api/v1/finish_alarm" => "alarm#finish"
    post "api/v1/poke" => "alarm#poke"

    get "api/v2/fetch_active_alarms" => "alarm#index_active_alternative"
    get "api/v2/fetch_alarms_poked" => "alarm#index_poked"

    get "api/v2/info" => "info#show"
    post 'api/v2/info' => "info#update"

  end

end
