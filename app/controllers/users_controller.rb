class UsersController < ApplicationController

  def new
    @user = User.new
    @title = "Sign up"
  end

  def show
    # 'params' is a standart Rails object to retrive the user id.
    # When we make the appropriate request to the Users controller, 
    # params[:id] will be the user id 1, so the effect is the same
    # as the find command: 'User.find(1)'.
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      # handle a succesful save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
end
