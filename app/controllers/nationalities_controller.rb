class NationalitiesController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def index
    @title = "Nationalities"
    @nationalities = Nationality.order("nationality")
  end

  def new
    @title = "New nationality"
    @nationality = Nationality.new
  end
  
  def create
    @nationality = Nationality.new(params[:nationality])
    if @nationality.save
      flash[:success] = "You have successfully added '#{@nationality.nationality}' to the list."
      redirect_to nationalities_path
    else
      @title = "New nationality"
      flash[:warning] = "The nationality was not added.  Please try again, making sure your entry isn't a duplicate."
      render 'new'
    end  
  end
  
  def edit
    @nationality = Nationality.find(params[:id])
    @title = "Edit nationality"
  end
  
  def update
    @nationality = Nationality.find(params[:id])
    if @nationality.update_attributes(params[:nationality])
      flash[:success] = "'#{@nationality.nationality}' updated."
      redirect_to nationalities_path
    else
      @title = "Edit nationality"
      render 'edit'
    end
  end
  
  def destroy
    @nationality = Nationality.find(params[:id])
    @nationality.destroy
    flash[:success] = "'#{@nationality.nationality}' has been successfully removed from the list."
    redirect_to nationalities_path
  end 

end
