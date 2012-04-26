class FixedleviesController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def new
    @country = Country.find(params[:country_id])
    @title = "New fixed levy"
    @fixedlevy = @country.fixedlevies.new
    @legislation = @country.legislation
  end
  
  def create
    @country = Country.find(params[:country_id])
    @legislation = @country.legislation
    @fixedlevy = @country.fixedlevies.new(params[:fixedlevy])
    if @fixedlevy.save
      flash[:success] = "You have successfully added a new fixed levy"
      redirect_to legislation_path(@legislation)
    else
      @title = "New fixed levy"
      flash[:warning] = "The fixed levy was not added.  Please try again, making sure all required fields are filled."
      render 'new'
    end  
  end

  def edit
    @title = "Edit fixed levy"
    @fixedlevy = Fixedlevy.find(params[:id])
    @country = Country.find(@fixedlevy.country_id)
    @legislation = @country.legislation
  end
  
  def update
    @fixedlevy = Fixedlevy.find(params[:id])
    @country = Country.find(@fixedlevy.country_id)
    @legislation = @country.legislation
    if @fixedlevy.update_attributes(params[:fixedlevy])
      flash[:success] = "Fixed levy updated."
      redirect_to legislation_path(@legislation)
    else
      @title = "Edit fixed levy"
      render 'edit'
    end
  end
  
  def destroy
    @fixedlevy = Fixedlevy.find(params[:id])
    @country = Country.find(@fixedlevy.country_id)
    @legislation = @country.legislation
    @fixedlevy.destroy
    flash[:success] = "A fixed levy has been successfully removed from the list."
    redirect_to legislation_path(@legislation)
  end


end
