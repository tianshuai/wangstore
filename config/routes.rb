Wangstore::Application.routes.draw do
	
  root to: 'home#index'

  #首页
  get 'about',       			to: 'home#about'
  get 'help',        			to: 'home#help'
  get 'choose',     			to: 'home#choose'

  #文章

  get 'posts/:mark',		to: 'posts#list',			as: 'posts'
  get 'post/:id',			to: 'posts#show', 			as: 'post'


  #上传路径
  post 'upload/editor',			to:	'upload#editor'

  #附件处理
  get "asset/*path" => "assets#serve"
  delete "asset/destroy" => "assets#destroy"
  post "asset/ajax_save_desc" => "assets#ajax_save_desc"
  

  #用户路由
  resources :users,					only: [:index, :new, :create, :show] 
  match 'user/edit_info',			to: 'users#edit_info',			via: :get
  match 'user/update_info',			to: 'users#update_info',		via: :patch

  #个人资料设置
  match 'user/edit_pwd',			to: 'users#edit_pwd',			via: :get
  match 'user/update_pwd',			to: 'users#update_pwd',			via: :patch
  match 'user/ajax_avatar_form',	to: 'users#ajax_avatar_form',	via: :get
  match 'user/ajax_validate_only',	to: 'users#ajax_validate_only',	via: :post
  get 'user/find_pwd',				to: 'users#find_pwd'
  get 'user/send_mail',			to: 'users#send_mail'
  get 'user/go_mail',				to: 'users#go_mail'
  get 'user/reset_pwd',				to: 'users#reset_pwd'
  match 'user/update_r_pwd',		to: 'users#update_r_pwd',		via: :patch

  #头像设置
  match 'user/edit_avatar',			to: 'users#edit_avatar',		via: :get


  resources :sessions, 				only: [:new, :create, :destroy]

  match '/signup',					to: 'users#new',				via: :get
  match '/signin',  				to: 'sessions#new',         	via: :get
  match '/signout', 				to: 'sessions#destroy',     	via: :delete


  #后台管理
  namespace :admin do
	#后台首页
	match '/home',				to: 'home#index',				via: :get

    #用户
    resources :users, only: [:index] do
	  collection do
		post :ajax_set_state
		post :ajax_set_role
	  end
    end

	#分类管理
    resources :categories do
	  collection do
		post :ajax_set_state
		post :destroy_more
        get :article_list
		get :ajax_change_category
	  end
    end

    #内容管理
    resources :posts do
	  collection do
		post :ajax_set_state
		post :destroy_more
		post :ajax_set_publish
		post :ajax_set_stick
	  end
    end

	#区块管理
    resources :blocks do
	  collection do
		post :destroy_more
	  end
    end

	#栏目位管理
    resources :column_spaces do
	  collection do
		post :destroy_more
		post :ajax_set_state
	  end
    end

	#栏目管理
    resources :columns do
	  collection do
		post :destroy_more
		post :ajax_set_state
	  end
	  member do

	  end
    end
 
  end

	
end
