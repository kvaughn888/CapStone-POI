Gmaps::Application.routes.draw do  
  resources :users
    get 'auth/:provider/callback', to: 'sessions#create_integration'
    get 'auth/failure', to: redirect('/')
    get 'signout', to: 'sessions#destroy', as: 'signout'
	
  get "sessions/new"
	get "sessions/create"
	get "sessions/destroy"
  get "sessions/login"
  get "sessions/home"
  get "sessions/profile"
  get "sessions/logout"
  
  post "sessions/login"
  post "sessions/home"
  post "users/show"
  
  get "comment/index"
  
  get 'home', to: 'home#index'
  get 'show_all', to: 'pois#index'
  get 'join_in', to: 'users#new'
  get 'all_images', to: 'home#all_images'
  get 'sign_in', to: 'sessions#login'
  get 'all_managers', to: 'home#all_managers'
  
  get '/application/request_role/:id', to: 'application#request_role', as: 'request_role'
  post '/application/request_role/:id', to: 'application#request_role'
  patch '/application/request_role/:id', to: 'application#request_role'
  
  get '/users/edit_role/:id', to: 'users#edit_role', as: 'edit_user_role'
  get '/users/update_role/:id', to: 'users#update_role'
  post '/users/update_role/:id', to: 'users#update_role'
  patch '/users/update_role/:id', to: 'users#update_role'
  
  get '/pois/:id/show_images', to: 'pois#show_images', as: 'show_images'
  
  get 'sessions/forgot_password', to: 'sessions#forgot_password', as: 'forgot_password'
  put 'sessions/forgot_password', to: 'sessions#send_password_reset_instructions'
  
  post "sessions/send_password_reset_instructions"
  
  get "password_reset" => "sessions#password_reset"
  put "password_reset" => "sessions#new_password"
  
  get '/comments/poi_comments/:id', to: 'comments#poi_comments', as: 'show_comments'
  
  get '/pois/about/:id', to: 'pois#edit'
  patch '/pois/about/:id', to: 'pois#edit'
  put '/pois/about/:id', to: 'pois#edit'
  
  post '/pois/:id', to: 'pois#update'
  patch '/pois/:id', to: 'pois#upload_image'
  put '/pois/:id', to: 'pois#upload_image'
  
  patch '/users/:id', to: 'users#upload_profile_image'
  put '/users/:id', to: 'users#upload_profile_image'
  
	get "home/index"
	get "pois/index"
	get "pois/show_all"
  get '/pois/show_users_pois', to: 'pois#show_users_pois', as: 'show_users_pois'
  
  get 'pois/delete_image/:file_name', to: 'pois#delete_image', as: 'delete_image'
  get 'users/delete_profile_image/:file_name', to: 'users#delete_profile_image', as: 'delete_profile_image'
  
  get 'comments/destroy/:id', to: 'comments#destroy', as: 'remove_comment'
  delete 'comments/destroy/:id/:poi_id', to: 'comments#destroy', as: 'delete_comment'
  
  get '/users/approve/:id', to: 'users#approve', as: 'approve'
  get '/users/disapprove/:id', to: 'users#disapprove', as: 'disapprove'
  
  get '/comments/comment_images/:id', to: 'comments#unapproved_images', as: 'show_unapproved_images'
  get '/comments/approved_images/:id', to: 'comments#approved_images', as: 'show_approved_images'
  
  get '/comments/:id/approve/image/:file_name', to: 'comments#approve_image', as: 'approve_image'
  get '/comments/:id/disapprove/image/:file_name', to: 'comments#disapprove_image', as: 'disapprove_image'
  get '/comments/:id/delete_approved/image/:file_name', to: 'comments#delete_approved_image', as: 'delete_approved_image'
	
	get '/comments/user_upload_image'
	post '/comments/user_upload_image', to: 'comments#user_upload_image'
	
	post '/pois/:id/new_title_image', to: 'pois#new_title_image'
	patch '/pois/:id/new_title_image', to: 'pois#new_title_image'
	
	
	
	
  get 'messages/index', to: 'messages#index', as: 'inbox'
  get 'messages/new', to: 'messages#new', as: 'new_message'
  
  get 'messages/create'
  post 'messages/create', to: 'messages#create'
  
  delete 'messages/destroy/:id', to: 'messages#destroy', as: 'delete_message'
  
  get 'messages/show/:id', to: 'messages#show', as: 'show_message'
  
  get 'messages/sent', to: 'messages#sent', as: 'sent'
  
  get 'pois/update_rating/:id/:rating', to: "pois#update_rating", as: 'update_rating'
  post 'pois/update_rating/:id/:rating', to: "pois#update_rating"
	
	resources :pois
      resources :sessions, only: [:create, :destroy]
    resources :comments
	
	root 'home#index'
end