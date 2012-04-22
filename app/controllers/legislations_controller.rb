class LegislationsController < ApplicationController
  
  before_filter :authenticate, :except => :update
  before_filter :check_legality, :only => :update
  before_filter :admin_user
  
  def show
    @title = "Other country rules"
    @legislation = Legislation.find(params[:id])
    @country = Country.find(@legislation.country_id)
  end

  def edit
    @legislation = Legislation.find(params[:id])
    @country = Country.find(@legislation.country_id)
    @title = "Edit country rules"
  end
  
  def update
    @legislation = Legislation.find(params[:id])
    @country = Country.find(@legislation.country_id)
    if @legislation.update_attributes(params[:legislation])
      flash[:success] = "Country rules updated."
      redirect_to @legislation
    else
      @title = "Edit country rules"
      render 'edit'
    end
  end
  
end
