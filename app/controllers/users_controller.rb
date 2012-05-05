class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  def new
    if not signed_in?
      @user = User.new
      @title = "Sign up"
    else
      redirect_to(root_path)
    end
  end
  def create
    if not signed_in?
      @user = User.new(params[:user])
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        @title = "Sign up"
        render 'new'
      end
    else
      redirect_to(root_path)
    end
  end
  def edit
 #   @user = User.find(params[:id])
    @title = "Edit user"
  end
  def update
  #  @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  private
    def authenticate
      deny_access unless signed_in?
## By default, before filters apply to every action in a controller, so here 
## we restrict the filter to act only on the :edit and :update actions by 
## passing the :only options hash.
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    def admin_user
      user = User.find(params[:id])
      redirect_to(root_path) if !current_user.admin? || current_user?(user)
    end
end
