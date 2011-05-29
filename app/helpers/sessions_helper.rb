module SessionsHelper

  def sign_in(user)
    user.remember_me!
    session[:remember_token] = user.remember_token
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end

  def user_from_remember_token
    remember_token = session[:remember_token]
    User.find_by_remember_token(remember_token) unless remember_token.nil?
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    reset_session
    self.current_user = nil
  end
end
