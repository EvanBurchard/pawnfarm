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
    redirect_to pawn_path(@pawn)
  end

  def execute
    puts params[:id]
    @pawn = Pawn.find(params[:id])
    @pawn.execute!
    redirect_to pawn_path(@pawn)
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
<<<<<<< HEAD:app/controllers/pawns_controller.rb
    oauth.set_callback_url("http://pawnfarm.com#{finalize_pawn_path}")      
    session['rtoken'] = @pawn.twitter_account.request_token = oauth.request_token.token
    session['rsecret'] = @pawn.twitter_account.request_secret = oauth.request_token.secret
    @pawn.twitter_account.save
    "http://#{oauth.request_token.authorize_url}"
    
=======
    setup = YAML::load(File.open(RAILS_ROOT + '/config/setup.yml'))
    oauth.set_callback_url("#{setup['server_url']}#{finalize_pawn_path}")      
    session['rtoken'] = @pawn.twitter_account.request_token = oauth.request_token.token
    session['rsecret'] = @pawn.twitter_account.request_secret = oauth.request_token.secret
    @pawn.twitter_account.save
    Rails::logger.info "http://#{oauth.request_token.authorize_url}"
    "#{oauth.request_token.authorize_url}"
>>>>>>> 25bd35a3aa49e3778e5e751b3dec810f237a5638:app/controllers/pawns_controller.rb
  end

  def assign_token_and_secret(oauth_verifier)
    @pawn = TwitterAccount.find_by_request_token_and_request_secret(session['rtoken'], session['rsecret']).pawn
    logger.info("oauth- #{oauth.inspect}")
    logger.info("request token- #{@pawn.twitter_account.request_token}, request secret- #{@pawn.twitter_account.request_secret}, oauth_verifier- #{oauth_verifier}")
    
    oauth.authorize_from_request(@pawn.twitter_account.request_token, @pawn.twitter_account.request_secret, oauth_verifier)
    @twitter_account = @pawn.twitter_account
    @twitter_account.access_key = oauth.access_token.token
    @twitter_account.access_secret = oauth.access_token.secret
    @twitter_account.save
  end

  
end
