SIFDBilleder::Application.routes.draw do
  root :to => "catalog#index"

  Blacklight.add_routes(self)
  #HydraHead.add_routes(self)

  devise_for :users

  resources :images


  #get '/loadalldata', to: 'images#loadallimagesfromfilesystem'
  get '/loadallxmlfiles', to: 'images#loadallxmlfromglobal'
  get '/deleteallobjects', to: 'images#emptysystem'
  get '/reloadsolrindex', to: 'images#reloadsolrindex'

  match '/login',                   :to => 'users/sessions#new',       :as => 'new_user_session'
  match '/auth/:provider/callback', :to => 'users/sessions#create',    :as => 'create_user_session'
  match '/logout',                  :to => 'users/sessions#destroy',   :as => 'destroy_user_session'
end
