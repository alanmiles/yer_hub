class SectorsController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def index
    @title = "Sectors"
    @sectors = Sector.order("approved ASC, sector")
  end
  
  def new
    @title = "New sector"
    @sector = Sector.new
    @creator = current_user.id
    @sector.created_by = @creator
  end
  
  def create
    @sector = Sector.new(params[:sector])
    if @sector.save
      flash[:success] = "You have successfully added '#{@sector.sector}'"
      redirect_to sectors_path
    else
      @title = "New sector"
      @creator = current_user.id
      @sector.created_by = @creator
      flash[:warning] = "The sector was not added.  Please try again."
      render 'new'
    end  
  end

  def edit
    @title = "Edit sector"
    @sector = Sector.find(params[:id])
  end
  
  def update
    @sector = Sector.find(params[:id])
    if @sector.update_attributes(params[:sector])
      flash[:success] = "Sector updated."
      redirect_to sectors_path
    else
      @title = "Edit sector"
      render 'edit'
    end
  end
  
  def destroy
    @sector = Sector.find(params[:id])
    @sector.destroy
    flash[:success] = "'#{@sector.sector}' has been successfully removed from the list."
    redirect_to sectors_path
  end

end
