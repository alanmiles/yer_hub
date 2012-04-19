class GratuityratesController < ApplicationController
 
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def index
    @country = Country.find(params[:country_id])
    @gratuityrates = @country.gratuityrates.order("gratuityrates.service_years_from")
    @title = "Gratuity rates"
  end
    
  def new
    @country = Country.find(params[:country_id])
    @title = "New gratuity rates"
    @gratuityrate = @country.gratuityrates.new
  end
  
  def create
    @country = Country.find(params[:country_id])
    @gratuityrate = @country.gratuityrates.new(params[:gratuityrate])
    if @gratuityrate.save
      flash[:success] = "You have successfully added new gratuity rates"
      redirect_to country_gratuityrates_path(@country)
    else
      @title = "New gratuity rate"
      flash[:warning] = "The gratuity rate was not added.  Please try again, making sure all required fields are filled."
      render 'new'
    end  
  end

  def edit
    @title = "Edit gratuity rates"
    @gratuityrate = Gratuityrate.find(params[:id])
    @country = Country.find(@gratuityrate.country_id)
  end
  
  def update
    @gratuityrate = Gratuityrate.find(params[:id])
    @country = Country.find(@gratuityrate.country_id)
    if @gratuityrate.update_attributes(params[:gratuityrate])
      flash[:success] = "Gratuity rates updated."
      redirect_to country_gratuityrates_path(@country)
    else
      @title = "Edit gratuity rate"
      render 'edit'
    end
  end
  
  def destroy
    @gratuityrate = Gratuityrate.find(params[:id])
    @country = Country.find(@gratuityrate.country_id)
    @gratuityrate .destroy
    flash[:success] = "A set of gratuity rates has been successfully removed from the list."
    redirect_to country_gratuityrates_path(@country)
  end

end
