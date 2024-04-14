class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_owner, only: [:edit, :update, :destroy]

  def new
    @new_group = Group.new
  end

  def create
    @new_group = Group.new(group_params)
    if @new_group.save
      @group_user = current_user.group_users.new(group_id: @new_group.id)
      @group_user.save
      redirect_to group_path(@new_group)
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update(group_params)
    redirect_to group_path(@group)
  end

  def show; end

  def index
    @groups = Group.all
  end

  def destroy
    @group.destroy
    redirect_to groups_path
  end

  def new_mail
    @group = Group.find(params[:group_id])
  end

  def send_group_mail
    @group = Group.find(params[:group_id])
    recipient_users = @group.users
    @mail_title = params[:mail_title]
    @mail_body = params[:mail_body]
    GroupMailer.send_group_mail(@mail_title, @mail_body, recipient_users, @group).deliver
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def authenticate_owner
    unless @group.owner_id == current_user.id
      redirect_to groups_path, notice: 'Only the group owner is allowed to do this action.'
    end
  end

  def group_params
    params.require(:group).permit(:name, :introduction, :owner_id, :image)
  end
end
