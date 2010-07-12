class PawnsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :can_edit?, :only => [:destroy, :edit, :update]
  before_filter :is_owner?, :only => [:show]

  def index
    @pawns = Pawn.all
  end
  
  def new
    @pawn = Pawn.new
    render :action => 'new'
  end
  
  def show
    @pawn = Pawn.find(params[:id])
  end
  
  def create
    @pawn = Pawn.new(params[:pawn])
    @pawn.user_id = current_user.id
    if @pawn.save and @pawn.setup_twitter_account
      redirect_to authorize_url
    else
      render :action => 'new'
    end
  end

  def edit
  end
  
  def update
    params[:pawn][:scheme_ids] ||= []  
    @pawn.update_attributes(params[:pawn])
    redirect_to pawn_path(@pawn)
  end

  def destroy
    Pawn.delete(@pawn)
    redirect_to pawns_path
  end
  
  def finalize
    assign_token_and_secret(params[:oauth_verifier])
    redirect to pawn_path(@pawn)
  end
  
  private 
  def assign_pawn
    @pawn = Pawn.find(params[:id])    
  end
  def is_owner?
    assign_pawn
    @is_owner = (@pawn.user == current_user)
  end
  def can_edit?
    unless is_owner?
      redirect_to pawn_path(@pawn)
    end
  end

  def authorize_url
    oauth.set_callback_url("http://pawnfarm.com#{finalize_pawn_path}")  
    @pawn.twitter_account.request_token = oauth.request_token.token
    @pawn.twitter_account.request_secret = oauth.request_token.secret

    "http://#{oauth.request_token.authorize_url}"
    
  end

  def assign_token_and_secret(oauth_verifier)
    oauth.authorize_from_request(rtoken, rsecret, oauth_verifier)
    #profile = Twitter::Base.new(oauth).verify_credentials
    #sign_in(profile)
    
    @pawn.twitter_account.atoken = oauth.access_token.token
    @pawn.twitter_account.asecret = oauth.access_token.secret
    @pawn.twitter_account.save
  end

  
end
