class UsersController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create]

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_confirmation_email
      redirect_to root_path, notice: "Please check your email to confirm your account."
    else
      render :new, status: :unprocessable_entity
    end

    def new
      @user = User.new
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
