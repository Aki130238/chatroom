class RoomsController < ApplicationController
  protect_from_forgery
  before_action :set_room, only: %i[ show edit update destroy ]

  def create
    @room = Room.create(user_id: current_user.id)
    @joinCurrentUser = RoomUser.create(user_id: current_user.id, room_id: @room.id)
    @joinUser = RoomUser.create(join_room_params)
    redirect_to room_path(@room.id)
  end

  def show
    @room = Room.find(params[:id])
    if RoomUser.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @RoomUsers = @room.room_users
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def join_user
    @room = Room.find(params[:id])
    unless RoomUser.where(user_id: join_room_user.id, room_id: @room.id).present?
      RoomUser.create(user_id: join_room_user.id, room_id: @room.id)
      redirect_to room_path(@room.id)
    end
  end

  private
  def set_room
    @current_room = Room.find(params[:id])
  end

  def join_room_params
    params.require(:room_user).permit(:user_id, :room_id).merge(room_id: @room.id)
  end

  def join_room_user
    @join_user = User.find_by(email: params[:room][:join_user])
  end
end
