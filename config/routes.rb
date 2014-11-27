require 'resque_web'

Cuicui::Application.routes.draw do
  default_url_options host: ENV['DOMAIN']

  scope '(:locale)', locale: /en|fr/ do
    as :user do
      patch '/user/confirmation' => 'confirmations#update',
            via: :patch, as: :update_user_confirmation
    end
    devise_for :users, controllers: {
      sessions: :sessions,
      registrations: :registrations,
      passwords: :passwords,
      confirmations: :confirmations
    }
    resources :users, only: [:show]

    # authenticated :user, lambda {|u| u.role == "admin"} do
    ResqueWeb::Engine.eager_load! if Rails.env.development?
    authenticated :user do
      mount ResqueWeb::Engine => '/resque'
    end

    get '/', to: 'home#show',
             as: 'home_root',
             constraints: { host: "www.#{ENV['DOMAIN']}" }
    root 'sections#show'

    resources :sites do
      resources :sections do
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
    get ':type.appcache', to: 'manifest#show', defaults: { format: :text }
    get '/sitemap.xml', to: 'sites#sitemap',
                        as: :sitemap,
                        defaults: { format: :xml }
    get 'favicon*all', to: 'favicons#show'
    get 'apple-touch-icon*all', to: 'favicons#show'
    get '/sections', to: 'sections#index'
    get '/:id', to: 'sections#show', as: :s_section
    get '/:section_id/:id', to: 'images#show', as: :s_image
  end
end
