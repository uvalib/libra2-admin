Rails.application.routes.draw do

	resources :work_files, only: [:create, :update, :destroy]
  resources :works, only: [:show, :update, :destroy] do
	  collection do
		  get 'all'
      get 'latest'
      get 'draft'
		  get 'submitted'
		  get 'computing_id'
	  end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :healthcheck, only: [ :index ]
  resources :version, only: [ :index ]

  # You can have the root of your site routed with "root"
  root 'works#draft'
end
