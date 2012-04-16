class InsurancerulesController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def show
    @title = "Insurance rule"
    @insurancerule = Insurancerule.find(params[:id])
  end
  
  def index
    @title = "Insurance rules"
    @countries = Country.joins(:insurancerule).order("countries.country")
  end
  
  def new
    @title = "New insurance rule"
    @insurancerule = Insurancerule.new
    @countries = Country.list_excluding_insrules_taken
  end
  
  def create
    @insurancerule = Insurancerule.new(params[:insurancerule])
    if @insurancerule.save
      flash[:success] = "You have successfully added a new insurance rule"
      redirect_to @insurancerule
    else
      @title = "New insurance rule"
      @countries = Country.list_excluding_insrules_taken
      flash[:warning] = "The insurance rule was not added.  Please try again."
      render 'new'
    end  
  end

  def edit
    @title = "Edit insurance rule"
    @insurancerule = Insurancerule.find(params[:id])
    @countries = Country.list_excluding_insrules_taken_except(@insurancerule.country_id)
  end
  
  def update
    @insurancerule = Insurancerule.find(params[:id])
    if @insurancerule.update_attributes(params[:insurancerule])
      flash[:success] = "Insurance rule updated."
      redirect_to @insurancerule
    else
      @title = "Edit insurance rule"
      @countries = Country.list_excluding_insrules_taken_except(@insurancerule.country_id)
      render 'edit'
    end
  end
  
  def destroy
    @insurancerule = Insurancerule.find(params[:id])
    @insurancerule.destroy
    flash[:success] = "The insurance rule for '#{@insurancerule.country.country}' has been successfully removed from the list."
    redirect_to insurancerules_path
  end

end
