class CreatePrivateInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :private_informations do |t|
      t.string :family_name, null: false
      t.string :first_name,  null: false
      t.string :family_kana, null: false
      t.string :first_kana,  null: false
      t.date :birthday,      null: false
      t.string :postal_code
      t.integer :prefectures
      t.string :city
      t.string :house_number
      t.string :building_name
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
