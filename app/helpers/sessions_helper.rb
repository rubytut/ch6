module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    # ||= (or equals) assignment operator is to set the @current_user instance variable
    # to the user corresponding to the remember token, but only if @current_user is undefined
    #
    # Which means that below construction calls the user_from_remember_token method the first
    # time current_user is called, but on subsequent invocations return @current_user witout
    # calling user_from_remember_token
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  private

  def user_from_remember_token
    # The '*' operator allows to use two-element array as an argument to a method expecting
    # to variables. The reason this is needed is that cookies.signed[:remember_me] returns
    # an array of two elements - the user id and the salt - but we want the 
    # authenticate_with_salt method to take two arguments, so that it can be invoked with
    # User.authenticate_with_salt(id, salt)
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil,nil]
  end
end
