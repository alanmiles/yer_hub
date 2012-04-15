class AbscatsController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def show
    @title = "Absence type"
    @abscat = Abscat.find(params[:id])
    @creator = User.find(@abscat.created_by)
  end
  
  def index
    @title = "Absence types"
    @abscats = Abscat.order("approved ASC, category")
  end
  
  def new
    @title = "New absence type"
    @abscat = Abscat.new
    @creator = current_user.id
    @abscat.created_by = @creator
  end
  
  def create
    @abscat = Abscat.new(params[:abscat])
    if @abscat.save
      flash[:success] = "You have successfully added a new absence type"
      redirect_to @abscat
    else
      @title = "New absence type"
      @creator = current_user.id
      @abscat.created_by = @creator
      flash[:warning] = "The absence type was not added.  Please try again."
      render 'new'
    end  
  end

  def edit
    @title = "Edit absence type"
    @abscat = Abscat.find(params[:id])
  end
  
  def update
    @abscat = Abscat.find(params[:id])
    if @abscat.update_attributes(params[:abscat])
      flash[:success] = "Absence type updated."
      redirect_to @abscat
    else
      @title = "Edit absence type"
      render 'edit'
    end
  end
  
  def destroy
    @abscat = Abscat.find(params[:id])
    @abscat.destroy
    flash[:success] = "'#{@abscat.category}' has been successfully removed from the list."
    redirect_to abscats_path
  end

end
