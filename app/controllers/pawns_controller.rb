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
    if @pawn.save
      redirect_to pawn_path(@pawn)
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
  
end
