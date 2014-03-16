Cuicui::Application.routes.draw do
  devise_for :users, controllers: { sessions: :sessions, registrations: :registrations }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
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
  get '/sitemap.xml', to: 'sites#sitemap', as: :sitemap, defaults: { format: :xml }
  get '/:id', to: 'pages#show', as: :s_page
  get '/:page_id/:id', to: 'images#show', as: :s_image

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
