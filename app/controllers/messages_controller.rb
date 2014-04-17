require 'fileutils'

class MessagesController < ApplicationController
  
  # Public: This gets all the messages and users for the index view to use.
  #
  def index
    @messages = Message.all
    @users = User.all
  end

  # Public: This gets all the users for the new view to use. It also creates a new
  # empty message to be able to send.
  #
  def new
    @users = User.all
    @message = Message.new
  end

  # Public: This gets the message by the id given from the url to show more information 
  # about the wanted message. It also gets all the users for the show view to use. It also 
  # updates the message's attribute has_read to true.
  #
  def show
    @message = Message.find(params[:id])
    @users = User.all
    @message.update_attribute(:has_read, true)
  end

  # Public: This gets all the messages and users for the sent view to use.
  #
  def sent
    @messages = Message.all
    @users = User.all
  end

  # Public: This creates and sends the new message to the correct user.
  #
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to inbox_path, notice: 'Message was successfully sent.' }
        format.json { render action: 'show', status: :created, location: inbox_path }
      else
        format.html { render action: 'new'}
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # Public: This destroies the given message by the id from the url.
  #
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to inbox_path
  end

  private
  
    def message_params
      params.require(:message).permit(:subject, :body, :sender, :recipient, :has_read)
    end

end
