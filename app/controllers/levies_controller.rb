class LeviesController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def new
    @country = Country.find(params[:country_id])
    @title = "New variable levy"
    @levy = @country.levies.new
    @legislation = @country.legislation
  end
  
  def create
    @country = Country.find(params[:country_id])
    @legislation = @country.legislation
    @levy = @country.levies.new(params[:levy])
    if @levy.save
      flash[:success] = "You have successfully added a new variable levy"
      redirect_to legislation_path(@legislation)
    else
      @title = "New variable levy"
      flash[:warning] = "The variable levy was not added.  Please try again, making sure all required fields are filled."
      render 'new'
    end  
  end

  def edit
    @title = "Edit variable levy"
    @levy = Levy.find(params[:id])
    @country = Country.find(@levy.country_id)
    @legislation = @country.legislation
  end
  
  def update
    @levy = Levy.find(params[:id])
    @country = Country.find(@levy.country_id)
    @legislation = @country.legislation
    if @levy.update_attributes(params[:levy])
      flash[:success] = "Variable levy updated."
      redirect_to legislation_path(@legislation)
    else
      @title = "Edit variable levy"
      render 'edit'
    end
  end
  
  def destroy
    @levy = Levy.find(params[:id])
    @country = Country.find(@levy.country_id)
    @legislation = @country.legislation
    @levy.destroy
    flash[:success] = "A variable levy has been successfully removed from the list."
    redirect_to legislation_path(@legislation)
  end

end
