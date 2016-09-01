Rails.application.routes.draw do
	resources :work_files, only: [:create, :update, :destroy]
  resources :works, only: [:index, :show, :update, :destroy] do
	  collection do
		  get 'draft'
		  get 'submitted'
	  end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :healthcheck, only: [ :index ]
  resources :version, only: [ :index ]
  # You can have the root of your site routed with "root"
  root 'dashboards#index'
end
