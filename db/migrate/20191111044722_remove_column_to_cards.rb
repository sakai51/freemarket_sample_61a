class RemoveColumnToCards < ActiveRecord::Migration[5.2]
  def change
    remove_column :cards, :number, :integer
    remove_column :cards, :expiration_month, :integer
    remove_column :cards, :expiration_year, :integer
    remove_column :cards, :security_code, :integer
  end
end
