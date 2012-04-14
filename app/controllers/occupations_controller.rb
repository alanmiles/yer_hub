class OccupationsController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def index
    @title = "Occupations"
    @occupations = Occupation.order("approved ASC, occupation")
  end
  
  def new
    @title = "New occupation"
    @occupation = Occupation.new
    @creator = current_user.id
    @occupation.created_by = @creator
  end
  
  def create
    @occupation = Occupation.new(params[:occupation])
    if @occupation.save
      flash[:success] = "You have successfully added '#{@occupation.occupation}'"
      redirect_to occupations_path
    else
      @title = "New occupation"
      @creator = current_user.id
      @occupation.created_by = @creator
      flash[:warning] = "The occupation was not added.  Please try again."
      render 'new'
    end  
  end

  def edit
    @title = "Edit occupation"
    @occupation = Occupation.find(params[:id])
  end
  
  def update
    @occupation = Occupation.find(params[:id])
    if @occupation.update_attributes(params[:occupation])
      flash[:success] = "Occupation updated."
      redirect_to occupations_path
    else
      @title = "Edit occupation"
      render 'edit'
    end
  end
  
  def destroy
    @occupation = Occupation.find(params[:id])
    @occupation.destroy
    flash[:success] = "'#{@occupation.occupation}' has been successfully removed from the list."
    redirect_to occupations_path
  end

end
