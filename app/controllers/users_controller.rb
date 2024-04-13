class UsersController < ApplicationController
  before_action :user_authenticate, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @new_book = Book.new

    @current_user_entries = current_user.entries
    @recipient_user_entries = @user.entries

    @current_user_entries.each do |c_u_entry|
      @recipient_user_entries.each do |r_u_entry|
        if c_u_entry.room_id == r_u_entry.room_id
          @room_exists = true
          @room = c_u_entry.room
        end
      end
    end
    @new_room = Room.new
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

  def user_authenticate
    @user = User.find(params[:id])
    if @user != current_user || @user.email == "guest@example.com"
      redirect_to user_path(current_user), notice: "You are not allowed this action"
    end
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :latitude, :longitude, :address, :postcode)
  end
end
