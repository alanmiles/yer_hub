class PagesController < ApplicationController
  
  before_filter :authenticate, :only => :admin_home
  before_filter :admin_user,   :only => :admin_home
  before_filter :not_admin_user, :only => :home
  
  def home
    @title = "Home"
    if signed_in?
      if current_user.admin?
        redirect_to admin_home_path
      end
    end
  end
  
  def admin_home
    @title = "Admin Home"
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end
end
