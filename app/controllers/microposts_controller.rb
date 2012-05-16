class MicropostsController < ApplicationController
  before_filter :authenticate, :only =>[:create, :destroy]
  before_filter :authorized_user, :only => :destroy
 # before_filter :find_user, :only => :index
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  def index
  #  de esta manera tb sirve
  #  @user = User.find(params[:id])
  #  @microposts = @user.microposts.paginate(:page => params[:page])
  #  o con redirect tambien sirve + el before filter + el find user de private
  #  redirect_to user_path(@user_id)
  #  pero yo elegi esta muhajajaj
    redirect_to user_path(params[:user_id])
  end
  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end
  private
    def authorized_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end
 #   def find_user
 #     @user_id = params[:user_id]
 #   end
end
