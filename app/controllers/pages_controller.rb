class PagesController < ApplicationController
  
  
  def home
    @title = "Home"
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
