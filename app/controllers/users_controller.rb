class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Yer Hub!"
      redirect_to @user
    else
      @user.password = nil
      @user.password_confirmation = nil
      @title = "Sign up"
      render "new"
    end
  end

end
