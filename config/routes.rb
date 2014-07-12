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
      get :next
    end
    resources :images, only: [:show, :create, :new] do
      collection do
        get :add # Amazon S3 hack.
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

  if Rails.env.production?
    offline = Rack::Offline.configure do
      cache ActionController::Base.helpers.asset_path('application.css')
      cache ActionController::Base.helpers.asset_path('application-dark.css')
      cache ActionController::Base.helpers.asset_path('application-light.css')
      %w(eot ttf svg woff).each do |ext|
        cache ActionController::Base.helpers.asset_path("entypo.#{ext}")
      end
      cache ActionController::Base.helpers.asset_path('application.js')
      network '*'
    end
    get '/application.manifest' => offline
  else
    get '/application.manifest' => Rails::Offline
  end

  get '/:id', to: 'pages#show', as: :s_page
  get '/:page_id/:id', to: 'images#show', as: :s_image
end
