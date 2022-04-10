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
    @pairRoomIds = RoomUser.group(:room_id).having('count(*) <= ?', 2).size.keys
    @pairRooms = RoomUser.where(room_id: @pairRoomIds)
    @havePairRoom = @pairRooms.where(user_id: params[:room][:user_ids])
    @userCurrentPairRoomId = @havePairRoom.group(:room_id).having('count(*) = ?', 2).size.keys
    @havePairRoomId = Room.find(@userCurrentPairRoomId.first) if @userCurrentPairRoomId.present?

    @room = current_user.rooms.build(room_params)
    if @havePairRoomId.blank?
      @room.save
      redirect_to room_path(@room), notice: "ルームを作成しました"
    else
      redirect_to rooms_path, notice: "既にルームが存在しています"
    end
  end

  def show
    @room = Room.find(params[:id])
    @room_users = @room.room_users
    if RoomUser.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @RoomUsers = @room.room_users
    end
  end

  
  private
  def set_room
    @current_room = Room.find(params[:id])
  end
  
  def room_params
    # if params.include?(:room)
      params.require(:room).permit(:name, {user_ids: []}).merge(user_id: current_user.id) 
    # else
    #   params.permit(:name, {user_ids: []}, :recipient_id).merge(user_id: current_user.id)
    # end
  end
  
  def have_rooms
    @have_rooms = Room.where(user_id: current_user.id)
  end
end
