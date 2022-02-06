class User < ApplicationRecord
  has_many :posts
  has_many :rooms
  has_many :room_users

end
