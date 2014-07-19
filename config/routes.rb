require 'resque_web'

Cuicui::Application.routes.draw do
  default_url_options host: ENV['DOMAIN']

  devise_for :users, controllers: {
    sessions: :sessions,
    registrations: :registrations,
    passwords: :passwords
  }

  # authenticated :user, lambda {|u| u.role == "admin"} do
  authenticated :user do
    mount ResqueWeb::Engine => '/resque'
  end

  root 'pages#first'

  resources :sites, only: [:show, :edit, :update, :index, :new, :create] do
    resources :pages do
      member do
        get :preview
        get :next
      end
      resources :images do
        collection do
          get :add # Amazon S3 hack.
          get :create # Hack for cloudinary !!
        end
      end
    end
  end

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

  get '/pages', to: 'pages#index'
  get '/:id', to: 'pages#show', as: :s_page
  get '/:page_id/:id', to: 'images#show', as: :s_image
end
