class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string     :family_name,   null: false
      t.string     :first_name,    null: false
      t.string     :family_kana,   null: false
      t.string     :first_kana,    null: false
      t.string     :postal_code,   null: false
      t.string     :prefectures,   null: false
      t.string     :city,          null: false
      t.string     :house_number,  null: false
      t.string     :building_name, null: false
      t.string     :phone_number,  null: false, unique: true
      t.references :user,          null: false, foreign_key: true
      t.timestamps
    end
  end
end
