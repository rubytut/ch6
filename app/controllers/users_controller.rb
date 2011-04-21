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
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      # clean password input boxes on failed signup
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end


  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end


  private

  def authenticate
    deny_access unless signed_in?
  end
end
