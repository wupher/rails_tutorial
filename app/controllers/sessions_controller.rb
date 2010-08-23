class SessionsController < ApplicationController
  def new
    @title = 'Sign In'
  end

  def destory
  end
  
  def create
    email =  params[:session][:email]
    password = params[:session][:password]
    user = User.authenticate(email, password)
    if user.nil?
      flash[:error] = "Illegal user email or password"
      @title = 'Sign In'
      render 'new'
    else
      sign_in user
      redirect_to user
    end
  end
end
