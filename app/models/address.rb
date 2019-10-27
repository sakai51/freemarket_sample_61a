class Address < ApplicationRecord
  belongs_to :user
  
  with_options presence: true do
    validates :family_name
    validates :first_name
    validates :family_kana
    validates :first_kana
    validates :postal_code
    validates :prefectures
    validates :city
    validates :house_number
    validates :building_name
    validates :phone_number
  end
end
