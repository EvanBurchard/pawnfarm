ActionController::Routing::Routes.draw do |map|
  map.login '/login', :controller => "user_sessions", :action => "new", :conditions => {:method => :get}
  map.connect '/login', :controller => "user_sessions", :action => "create", :conditions => {:method => :post}
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'

  map.finalize_pawn "/pawns/finalize", :controller => "pawns", :action => "finalize"
  map.finalize_pawn "/pawns/:id/execute", :controller => "pawns", :action => "execute"
  map.turk_form "turk_forms/:id", :controller => "turk_forms", :action => "show"
  
  map.resource :user_session
  map.root :controller => "home", :action => "index"

  map.resource :account, :controller => "users"
  map.resources :users
  map.resources :pawns
  map.resources :schemes
end
