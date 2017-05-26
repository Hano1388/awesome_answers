class SessionsController < ApplicationController

  def new

  end

  def create
    # We have the user's email and password from the params
    # 1. find the user by their email
    # 2. if found, we authenticate the user with the given password
    # 3. if not found, we alert the user with wrong credentials

    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: 'Thank you for signing in! ❤️'
    else
      # flash.now makes the flash message available to the current request as oppesed to next request with just 'flash'
      flash.now[:aler] = 'Wrong Credentials!'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_path, notice: 'Signed Out! 👋'
  end

end
