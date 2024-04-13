class RoomsController < ApplicationController
  def create
    @room = Room.new(user_id: current_user.id)
    @room.save
    @current_user_entry = Entry.create(:room_id => @room.id, user_id: current_user.id)
    @invited_user_entry = Entry.create(:room_id => @room.id, user_id: params[:room][:user_id])
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
      @messages = @room.messages
      @entries = @room.entries
      @new_message = Message.new
      @entries.each do |entry|
        if entry.user_id != current_user.id
          @recipient_user = User.find(entry.user_id)
        end
      end
      @current_user = current_user
    end
  end
end
