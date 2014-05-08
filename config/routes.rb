Cuicui::Application.routes.draw do
  devise_for :users, controllers: {
    sessions: :sessions,
    registrations: :registrations,
    passwords: :passwords
  }
  root 'pages#first'

  resources :sites, only: [:show, :edit, :update] do
    resources :pages, shallow: true
  end

  resources :pages do
    member do
      get :preview
    end
    resources :images, only: [:show, :create] do
      collection do
        get :create # Hack for cloudinary !!
      end
    end
  end

  resources :images, only: [:show, :destroy, :edit, :update]

  devise_scope :user do
    get '/admin', to: 'sessions#new'
  end

  get '/robots.txt', to: 'sites#robots', defaults: { format: :txt }
  get '/sitemap.xml', to: 'sites#sitemap',
                      as: :sitemap,
                      defaults: { format: :xml }
  get '/:id', to: 'pages#show', as: :s_page
  get '/:page_id/:id', to: 'images#show', as: :s_image
end
