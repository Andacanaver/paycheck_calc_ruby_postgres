class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create]
  before_action :authenticate_user!, only: [:destroy]

  def create
    @user = User.authenticate_by(email: params[:user][:email].downcase)
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: "Incorrect email or password."
      else
        after_login_path = session[:after_login_path] || root_path
        login @user
        remember(@user) if params[:user][:remember_me] == "1"
        redirect_to after_login_path, notice: "You have been logged in."
      end
    else
      flash.now[:alert] = "Incorrect email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget(current_user)
    logout
    redirect_to root_path, notice: "You have been logged out."
  end

  def new
  end

end
