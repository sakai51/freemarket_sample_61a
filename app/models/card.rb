class Card < ApplicationRecord
  belongs_to :user

  valudates :number, presences: true
end