class EnterprisesController < ApplicationController
  
  before_filter :authenticate
  
  def new
    @title = "New enterprise"
    @enterprise = Enterprise.new
    @enterprise.created_by = current_user.id
    @countries = Country.order("country")
    @sectors = Sector.where("approved = ?", true).order("sector")
    
  end
  
  def create
    @enterprise = Enterprise.new(params[:enterprise])
    if @enterprise.save
      flash[:success] = "You have successfully added '#{@enterprise.name}'"
      redirect_to @enterprise
    else
      @title = "New enterprise"
      @countries = Country.order("country")
      @sectors = Sector.where("approved = ?", true).order("sector")
      flash[:warning] = "The enterprise was not added.  Please try again, making sure all required fields (*) are filled."
      render 'new'
    end  
  end
  
  def show
    @enterprise = Enterprise.find(params[:id])
    @title = "Enterprise"
  end

end
