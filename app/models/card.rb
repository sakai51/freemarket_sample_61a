class Card < ApplicationRecord
  belongs_to :user

  # validates :number, :expiration_month, :expiration_year, :user, :security_code, presence: true

  enum expiration_month: {
    "01":1, "02":2, "03":3, "04":4, "05":5, "06":6,
    "07":7 ,"08":8 ,"09":9 ,"10":10 ,"11":11 ,"12":12
  }

end
