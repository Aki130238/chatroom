class RoomsController < ApplicationController
  protect_from_forgery
  before_action :set_room, only: %i[ show edit update destroy ]

  def index
    @current_rooms = current_user.rooms
    @join_rooms = RoomUser.where(user_id: current_user.id)
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)
    @room.save
    redirect_to room_path(@room)
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

  
  private
  def set_room
    @current_room = Room.find(params[:id])
  end
  
  def room_params
    params.require(:room).permit(:name, {user_ids: []}).merge(user_id: current_user.id)
  end
  
  def have_rooms
    @have_rooms = Room.where(user_id: current_user.id)
  end
  # def join_user
  #   @room = Room.find(params[:id])
  #   unless RoomUser.where(user_id: join_room_user.id, room_id: @room.id).present?
  #     RoomUser.create(user_id: join_room_user.id, room_id: @room.id)
  #     redirect_to room_path(@room.id)
  #   end
  # end
end
