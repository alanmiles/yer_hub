class SicknessallowancesController < ApplicationController
 
 
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def index
    @country = Country.find(params[:country_id])
    @sicknessallowances = @country.sicknessallowances.order("sicknessallowances.sick_days_from")
    @title = "Sickness allowances"
  end
    
  def new
    @country = Country.find(params[:country_id])
    @title = "New sickness allowances"
    @sicknessallowance = @country.sicknessallowances.new
  end
  
  def create
    @country = Country.find(params[:country_id])
    @sicknessallowance = @country.sicknessallowances.new(params[:sicknessallowance])
    if @sicknessallowance.save
      flash[:success] = "You have successfully added a new sickness allowance"
      redirect_to country_sicknessallowances_path(@country)
    else
      @title = "New sickness allowance"
      flash[:warning] = "The sickness allowance was not added.  Please try again, making sure all required fields are filled."
      render 'new'
    end  
  end

  def edit
    @title = "Edit sickness allowance"
    @sicknessallowance = Sicknessallowance.find(params[:id])
    @country = Country.find(@sicknessallowance.country_id)
  end
  
  def update
    @sicknessallowance = Sicknessallowance.find(params[:id])
    @country = Country.find(@sicknessallowance.country_id)
    if @sicknessallowance.update_attributes(params[:sicknessallowance])
      flash[:success] = "Sickness allowance updated."
      redirect_to country_sicknessallowances_path(@country)
    else
      @title = "Edit sickness allowance"
      render 'edit'
    end
  end
  
  def destroy
    @sicknessallowance = Sicknessallowance.find(params[:id])
    @country = Country.find(@sicknessallowance.country_id)
    @sicknessallowance .destroy
    flash[:success] = "A sickness allowance has been successfully removed from the list."
    redirect_to country_sicknessallowances_path(@country)
  end

end
