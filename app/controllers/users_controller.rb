class UsersController < ApplicationController
  def new
    @title = 'Sign Up'
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = 'welcome to the sample app'
      redirect_to @user
    else
      flash[:fail] = 'Something wrong with your signing-up'
      @title = 'Sign Up'
      render 'new'
    end
  end
end
