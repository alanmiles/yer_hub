module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def expel
    flash[:warning] = "Please use the correct HeaRt controls - you were not authorized to take this action!"
    redirect_to root_path  
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
    
    def authenticate
      deny_access unless signed_in?
    end
    
    def check_legality
      expel unless signed_in?
    end
  
    def admin_user
      unless current_user.admin?
        flash[:warning] = "Please use the HeaRt controls correctly - the action you requested is only available to administrators"
        redirect_to root_path
      end
    end
    
    def not_admin_user
      if signed_in?
        if current_user.admin?
          redirect_back_or admin_home_path
        end
      end
    end      
end
