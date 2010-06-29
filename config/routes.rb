ActionController::Routing::Routes.draw do |map|
  map.login '/login', :controller => "user_sessions", :action => "new", :conditions => {:method => :get}
  map.connect '/login', :controller => "user_sessions", :action => "create", :conditions => {:method => :post}
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'

  map.resource :user_session
  map.root :controller => "home", :action => "index"

  map.resource :account, :controller => "users"
  map.resources :users
end
