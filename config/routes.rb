Wangstore::Application.routes.draw do
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
	
  root to: 'home#index'

  #首页
  get 'about',       			to: 'home#about'
  get 'help',        			to: 'home#help'
  get 'choose',     			to: 'home#choose'
  

  #用户路由
  resources :users,					only: [:index, :new, :create, :show] 
  match 'user/edit_info',			to: 'users#edit_info',			via: :get
  match 'user/update_info',			to: 'users#update_info',		via: :patch

  #个人资料设置
  match 'user/edit_pwd',			to: 'users#edit_pwd',			via: :get
  match 'user/update_pwd',			to: 'users#update_pwd',			via: :patch
  match 'user/ajax_avatar_form',	to: 'users#ajax_avatar_form',	via: :get
  post 'user/ajax_validate_only',	to: 'users#ajax_validate_only'
  get 'user/find_pwd',				to: 'users#find_pwd'
  get 'user/send_mail',			to: 'users#send_mail'
  get 'user/go_mail',				to: 'users#go_mail'
  get 'user/reset_pwd',				to: 'users#reset_pwd'
  put 'user/update_r_pwd',			to: 'users#update_r_pwd'

  #头像设置
  match 'user/edit_avatar',			to: 'users#edit_avatar',		via: :get


  resources :sessions, 				only: [:new, :create, :destroy]

  match '/signup',					to: 'users#new',				via: :get
  match '/signin',  				to: 'sessions#new',         	via: :get
  match '/signout', 				to: 'sessions#destroy',     	via: :delete
	
end
