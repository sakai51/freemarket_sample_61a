class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :purchaces
  has_many :cards
  has_one  :private_information
  has_one  :address

  validates :nickname, presence: true, length: { maximum: 6 }
end