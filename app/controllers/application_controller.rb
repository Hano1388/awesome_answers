class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # If you need a method that is available to all your controllers and views, define it in this controller and turn it into a helper_method with the 'helper_method' method

  def user_signed_in?

    # the folowing is to prevent the app from crashing if we have the user_id in the session and no user with that id in the database.
    # this accures when the logged in user is deleted
    if session[:user_id].present? && current_user.nil?
      session[:user_id] = nil
    end
    session[:user_id].present?
  end

  # Below 👇 'helper_method' makes the above 👆 method 'user_signed_in?' available to all my views
  helper_method :user_signed_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  helper_method :current_user #, :user_signed_in?

  def authenticate_user!
    if !user_signed_in?
      redirect_to new_session_path, notice: 'Please sign in!'
    end
  end
end
