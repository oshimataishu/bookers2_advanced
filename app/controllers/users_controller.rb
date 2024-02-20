class UsersController < ApplicationController
  before_action :is_matching_user, only: [:edit, :update]
  def show
    @user = User.find(params[:id])
    @new_book = Book.new
  end

  def index
    @users = User.all
    @new_book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "User updated successfully"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

  def is_matching_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
