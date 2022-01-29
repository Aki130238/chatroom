class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  skip_before_action :login_required

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @currentRoomUser = RoomUser.where(user_id: current_user.id)  #current_userが既にルームに参加しているか判断
    @receiveUser = RoomUser.where(user_id: @user.id)  #他の@userがルームに参加しているか判断
    
    # if @user.id == current_user.id  #current_userと@userが一致なら
    #   if @haveroom.nil?    #ルームが同じじゃなければ
    #     #新しいインスタンスを生成
    #     @room = Room.new
    #     @RoomUser = RoomUser.new
    #     #//新しいインスタンスを生成
    #   end
    #       #current_userが参加していルームを取り出す
    #   @receiveUser.each do |u|    #@userが参加しているルームを取り出す
    #   end
    # else
    #   @currentRoomUser.each do |cu|    #current_userが参加していルームを取り出す
    #     @receiveUser.each do |u|    #@userが参加しているルームを取り出す
    #       if cu.room_id == u.room_id    #current_userと@userのルームが同じか判断(既にルームが作られているか)
    #         @haveRoom = true    #falseの時(同じじゃない時)の条件を記述するために変数に代入
    #         @roomId = cu.room_id   #ルームが共通しているcurrent_userと@userに対して変数を指定
    #       # else
    #       #   @haveRoom = false    #falseの時(同じじゃない時)の条件を記述するために変数に代入
    #       #   @roomId = u.room_id   #ルームが共通しているcurrent_userと@userに対して変数を指定
    #       end
    #     end
    #   end
    # end

    unless @user.id == current_user.id  #current_userと@userが一致していなければ
      @currentRoomUser.each do |cu|    #current_userが参加していルームを取り出す
        @receiveUser.each do |u|    #@userが参加しているルームを取り出す
          if cu.room_id == u.room_id    #current_userと@userのルームが同じか判断(既にルームが作られているか)
            @haveRoom = true    #falseの時(同じじゃない時)の条件を記述するために変数に代入
            @roomId = cu.room_id   #ルームが共通しているcurrent_userと@userに対して変数を指定
          # else
          #   @haveRoom = false    #falseの時(同じじゃない時)の条件を記述するために変数に代入
          #   @roomId = u.room_id   #ルームが共通しているcurrent_userと@userに対して変数を指定
          end
        end
      end
      unless @haveroom    #ルームが同じじゃなければ
        #新しいインスタンスを生成
        @room = Room.new
        @RoomUser = RoomUser.new
        #//新しいインスタンスを生成
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
