Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
    with_options constraints: lambda {|req| req.format == :json} do |json_only|
      json_only.resources :inspection_types, only: [:index, :show] do
        json_only.resources :questions, only: [:index]
        json_only.resources :inspections, only: [:index, :show, :update]
      end

    end
end
