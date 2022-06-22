class ConfirmationsController < ApplicationController

  def create
    @user = User.find_by(email: params[:user][:email].downcase)

    if @user.present? && @user.unconfirmed?
      @user.send_confirmation_email!
      redirect_to root_path, notice: "Please check your email to confirm your account."
    else
      redirect_to root_path, alert: "User not found."
    end
  end

  def edit
    @user = User.find_signed(params[:confirmaiton_token], purpose: :confirm_email)

    if @user.present?
      @user.confirm!
      login @user
      redirect_to root_path, notice: "Your account has been confirmed."
    else
      redirect_to root_path, alert: "Invalid confirmation token."
    end
  end

  def new
    @user = User.new
  end
end
