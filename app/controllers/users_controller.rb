class UsersController < ApplicationController
  before_filter :authenticate, :except => [:show, :new, :create]
##  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  # By default, before filters apply to every action in a controller,
  # so here we restrict the filter to act only on the
  # :edit and :update actions by passing the :only options hash.

  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy

  def new
    @user = User.new
    if signed_in? 
      redirect_to root_path
    end
    @title = "Sign up"
  end

  def index
    @title = "All users"
    ##@users = User.all
    @users = User.paginate(:page => params[:page])
  end

  def show
    # 'params' is a standart Rails object to retrive the user id.
    # When we make the appropriate request to the Users controller, 
    # params[:id] will be the user id 1, so the effect is the same
    # as the find command: 'User.find(1)'.
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  def create
    @user = User.new(params[:user])
    if signed_in?
      redirect_to root_path
    elsif @user.save
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

  def destroy
      usr = User.find(params[:id])
      if usr.admin?
        redirect_to root_path
      else
        usr.destroy
        flash[:success] = "User destroyed."
        redirect_to users_path
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


  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  private

#  def authenticate
#    deny_access unless signed_in?
#  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end


end
