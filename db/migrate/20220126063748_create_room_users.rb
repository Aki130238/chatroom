class CreateRoomUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :room_users do |t|
      t.references :user, null: false, foreign_key: true, null: false, index: false
      t.references :room, null: false, foreign_key: true, null: false

      t.timestamps
    end
    add_index :room_users, [:user_id, :room_id], unique: true
  end
end
