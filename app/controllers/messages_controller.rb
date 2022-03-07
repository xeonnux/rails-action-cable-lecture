class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    # into the form create a new message
    @message = Message.new(message_params)
    # message needs chatroom
    @message.chatroom = @chatroom
    # message needs user
    @message.user = current_user
    # save the message
    if @message.save
      ChatroomChannel.broadcast_to(
        @chatroom, render_to_string( partial: "message", locals: {message: @message})
      )
    else
      render 'chatrooms/show'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
