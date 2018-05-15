class UsersController < ApplicationController
  def new
    session[:user_id] = nil
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.set_keys
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Logged in as #{@user.username}"
      UserMailer.with(user: @user).create_activation.deliver_now

      redirect_to dashboard_path
    else
      flash.now[:error] = "Failed to create a new account"
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :email)
    end
end
