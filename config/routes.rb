require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  get 'users/new'

  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'planetside2' => 'static_pages#planetside2'
  get 'nazizombies' => 'static_pages#nazizombies'
  get 'admin' => 'static_pages#admin'
  get 'jsdemo' => 'static_pages#jsdemo'

  get 'signup' => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  get 'recent_posts/:id' => 'users#posts', as: :user_posts
  get 'recent_comments/:id' => 'users#comments', as: :user_comments
  get 'purchase_item/:id' => 'items#purchase', as: :purchase

  #get 'friendships/:id' => 'users#friendships', as: :user_friendships


  resources :users, shallow: true do
    resources :pictures
    resources :avatars
    resources :likes, only: [:index]
    resources :friendships, only: [:index]
    resources :notifications, only: [:index]
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  resources :forums, shallow: true do
    resources :subforums
  end

  resources :subforums, shallow: true do
    resources :posts
  end

  resources :posts, shallow: true do
    resources :comments
    resources :pictures
    post 'toggle' => 'posts#toggle_sticky' as: :sticky_post_path
  end

  resources :comments

  resources :items, shallow: true do
    resources :pictures
  end

  resources :pictures, only: [:index]

  resources :likes, only: [:new, :create, :index, :destroy]

  resources :friendships, only: [:create, :index, :update, :destroy]

  resources :notification_configurations, only: [:create, :edit, :update]

  resources :notifications, only: [:create, :destroy, :update]

  resources :avatars


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
