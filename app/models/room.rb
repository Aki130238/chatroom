class Room < ApplicationRecord
  has_many :room_users
  # accepts_nested_attributes_for :room_users, reject_if: :all_blank
  has_many :users, through: :room_users
  has_many :messages, dependent: :destroy
end
