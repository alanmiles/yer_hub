class AddAccountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :administrator, :boolean, :default => false
    add_column :users, :pin, :string
  end
end
