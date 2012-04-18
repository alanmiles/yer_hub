class InsuranceratesController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  #def show
  #  @title = "Insurance rate"
  #  @insurancerate = Insurancerate.find(params[:id])
  #  @country = Country.find(@insurancerate.country_id)
  #  @insurancerule = @country.insurancerule
  #end
  
  #def index
  #  @country = Country.find(params[:country_id])
  #  @title = "Insurance rates"
  #  @insurancerates = @country.insurancerates.order("insurancerates.position")
  #end
  
  def new
    @country = Country.find(params[:country_id])
    @title = "New insurance rate"
    @insurancerate = @country.insurancerates.new
    @insurancerule = @country.insurancerule
  end
  
  def create
    @country = Country.find(params[:country_id])
    @insurancerule = @country.insurancerule
    @insurancerate = @country.insurancerates.new(params[:insurancerate])
    if @insurancerate.save
      flash[:success] = "You have successfully added a new insurance rate"
      redirect_to insurancerule_path(@insurancerule)
    else
      @title = "New insurance rate for #{@country.country}"
      flash[:warning] = "The insurance rate was not added.  Please try again, making sure all required fields are filled."
      render 'new'
    end  
  end

  def edit
    @title = "Edit insurance rate"
    @insurancerate = Insurancerate.find(params[:id])
    @country = Country.find(@insurancerate.country_id)
    @insurancerule = @country.insurancerule
  end
  
  def update
    @insurancerate = Insurancerate.find(params[:id])
    @country = Country.find(@insurancerate.country_id)
    @insurancerule = @country.insurancerule
    if @insurancerate.update_attributes(params[:insurancerate])
      flash[:success] = "Insurance rate updated."
      redirect_to insurancerule_path(@insurancerule)
    else
      @title = "Edit insurance rate"
      render 'edit'
    end
  end
  
  def destroy
    @insurancerate = Insurancerate.find(params[:id])
    @country = Country.find(@insurancerate.country_id)
    @insurancerule = @country.insurancerule
    @insurancerate.destroy
    flash[:success] = "A set of insurance rates has been successfully removed from the list."
    redirect_to insurancerule_path(@insurancerule)
  end
end
