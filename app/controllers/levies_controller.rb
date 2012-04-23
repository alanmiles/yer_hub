class LeviesController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def new
    @country = Country.find(params[:country_id])
    @title = "New levy"
    @levy = @country.levies.new
    @legislation = @country.legislation
  end
  
  def create
    @country = Country.find(params[:country_id])
    @legislation = @country.legislation
    @levy = @country.levies.new(params[:levy])
    if @levy.save
      flash[:success] = "You have successfully added a new levy"
      redirect_to legislation_path(@legislation)
    else
      @title = "New levy"
      flash[:warning] = "The levy was not added.  Please try again, making sure all required fields are filled."
      render 'new'
    end  
  end

  def edit
    @title = "Edit levy"
    @levy = Levy.find(params[:id])
    @country = Country.find(@levy.country_id)
    @legislation = @country.legislation
  end
  
  def update
    @levy = Levy.find(params[:id])
    @country = Country.find(@levy.country_id)
    @legislation = @country.legislation
    if @levy.update_attributes(params[:levy])
      flash[:success] = "Levy updated."
      redirect_to legislation_path(@legislation)
    else
      @title = "Edit levy"
      render 'edit'
    end
  end
  
  def destroy
    @levy = Levy.find(params[:id])
    @country = Country.find(@levy.country_id)
    @legislation = @country.legislation
    @levy.destroy
    flash[:success] = "A levy has been successfully removed from the list."
    redirect_to legislation_path(@legislation)
  end

end
