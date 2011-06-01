class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :stop_admin_from_deleting_himself, :only => :destroy
  before_filter :redirect_signed_in_user_on_sign_up, :only => [:new, :create]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
	  @title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
	    flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
	    @user.password = ""
	    @user.password_confirmation = ""
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def destroy
    @user.destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  private
	
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
	
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
	
	  def stop_admin_from_deleting_himself
	    @user = User.find(params[:id])
	    if current_user.admin? and current_user?(@user)
	      flash[:notice] = "You cannot delete yourself"
		    redirect_to users_path
	    end
	  end
	
	  def redirect_signed_in_user_on_sign_up
	    if signed_in?
		    flash[:notice] = "Cannot create user when signed in"
		    redirect_to root_path
	    end
	  end
end
