class CurrenciesController < ApplicationController
  
  before_filter :authenticate, :except => [:create, :update, :destroy]
  before_filter :check_legality, :only => [:create, :update, :destroy]
  before_filter :admin_user
  
  def show
    @title = "Currency"
    @currency = Currency.find(params[:id])
    @creator = User.find(@currency.created_by)
  end
  
  def index
    @title = "Currencies"
    @currencies = Currency.order("approved, currency")
  end
  
  def new
    @title = "New currency"
    @currency = Currency.new
    @creator = current_user.id
    @currency.created_by = @creator
  end
  
  def create
    @currency = Currency.new(params[:currency])
    if @currency.save
      flash[:success] = "You have successfully added a new currency"
      redirect_to @currency
    else
      @title = "New currency"
      @creator = current_user.id
      @currency.created_by = @creator
      flash[:warning] = "The currency was not added.  Please try again, making sure all required fields are filled."
      render 'new'
    end  
  end

  def edit
    @title = "Edit currency"
    @currency = Currency.find(params[:id])
  end
  
  def update
    @currency = Currency.find(params[:id])
    if @currency.update_attributes(params[:currency])
      flash[:success] = "Currency updated."
      redirect_to @currency
    else
      @title = "Edit currency"
      render 'edit'
    end
  end
  
  def destroy
    @currency = Currency.find(params[:id])
    @currency.destroy
    flash[:success] = "'#{@currency.currency}' has been successfully removed from the list."
    redirect_to currencies_path
  end
end
