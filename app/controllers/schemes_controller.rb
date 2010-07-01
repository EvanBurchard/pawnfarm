class SchemesController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  before_filter :can_edit?, :only => [:destroy, :edit, :update]
  before_filter :is_owner?, :only => [:show]
    
  def index
    @schemes = Scheme.all
  end
  
  def new
    @scheme = Scheme.new
    render :action => 'new'
  end
  
  def show
    @scheme = Scheme.find(params[:id])
  end
  
  def create
    @scheme = params[:scheme][:type].constantize.new(params[:scheme])
    
    @scheme.user_id = current_user.id
    if @scheme.save
      redirect_to scheme_path(@scheme)
    else
      render :action => 'new'
    end
  end

  def edit
  end
  
  def update
    @scheme.update_attributes(params[:scheme])
    redirect_to scheme_path(@scheme)
  end

  def destroy
    Scheme.delete(@scheme)
    redirect_to schemes_path
  end
  
  private 
  def assign_scheme
    @scheme = Scheme.find(params[:id])    
  end
  def is_owner?
    assign_scheme
    @is_owner = (@scheme.user == current_user)
  end
  def can_edit?
    unless is_owner?
      redirect_to scheme_path(@scheme)
    end
  end
  
end
