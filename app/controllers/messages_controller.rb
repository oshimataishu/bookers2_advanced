class MessagesController < ApplicationController
  def create
    @new_message = Message.new(message_params)
    if @new_message.save
      redirect_to request.referer
    else
      render template: "rooms/show"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :user_id, :room_id)
  end
end
