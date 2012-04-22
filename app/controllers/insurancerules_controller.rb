class InsurancerulesController < ApplicationController
  
  before_filter :authenticate, :except => :update
  before_filter :check_legality, :only => :update
  before_filter :admin_user
  
  def show
    @title = "Insurance"
    @insurancerule = Insurancerule.find(params[:id])
    @country = Country.find(@insurancerule.country_id)
    @insurancerates = @country.insurancerates.order("insurancerates.low_salary")
  end

  def edit
    @insurancerule = Insurancerule.find(params[:id])
    @country = Country.find(@insurancerule.country_id)
    #@country = Country.find(params[:id])
    #@insurancerule = @country.insurancerule
    @title = "Edit insurance rule"
  end
  
  def update
    @insurancerule = Insurancerule.find(params[:id])
    @country = Country.find(@insurancerule.country_id)
    if @insurancerule.update_attributes(params[:insurancerule])
      flash[:success] = "Insurance rule updated."
      redirect_to @insurancerule
    else
      @title = "Edit insurance rule"
      render 'edit'
    end
  end

end
