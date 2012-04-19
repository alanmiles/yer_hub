class CountriesController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def index
    @title = "Countries"
    @countries = Country.paginate(:page => params[:page]).order("country")
  end
  
  def new
    @title = "New country"
    @country = Country.new
    @nationalities = Nationality.order("nationality")
    @currencies = Currency.where("approved = ?", true).order("currency")
  end
  
  def create
    @country = Country.new(params[:country])
    if @country.save
      flash[:success] = "You have successfully added '#{@country.country}'"
      redirect_to countries_path
    else
      @title = "New country"
      @nationalities = Nationality.order("nationality")
      @currencies = Currency.where("approved = ?", true).order("currency")
      flash[:warning] = "The country was not added.  Please try again, making sure all required fields are filled."
      render 'new'
    end  
  end

  def edit
    @title = "Edit country"
    @country = Country.find(params[:id])
    @nationalities = Nationality.order("nationality")
    @currencies = Currency.where("approved = ?", true).order("currency")
  end
  
  def update
    @country = Country.find(params[:id])
    if @country.update_attributes(params[:country])
      flash[:success] = "'#{@country.country}' updated."
      redirect_to countries_path
    else
      @title = "Edit country"
      @nationalities = Nationality.order("nationality")
      @currencies = Currency.where("approved = ?", true).order("currency")
      render 'edit'
    end
  end
  
  def destroy
    @country = Country.find(params[:id])
    @country.destroy
    flash[:success] = "'#{@country.country}' has been successfully removed from the list."
    redirect_to countries_path
  end

end
