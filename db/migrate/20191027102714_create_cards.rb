class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.integer     :number,    null: false, unique: true
      t.integer     :security,  null: false, unique: true
      t.references  :user,      null: false, foreign_key: true
      t.timestamps
    end
  end
end
