class ActivateController < ApplicationController
  def index
    user = User.find(params[:id])
    user.activate(params[:token])

    if user.active
      flash[:success] = "Thank you! Your account is now activated."
    else
      flash[:error] = "Unable to activate that account"
    end
    redirect_to root_path
  end
end
