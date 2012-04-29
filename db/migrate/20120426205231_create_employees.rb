class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :user_id
      t.integer :enterprise_id
      t.boolean :officer, :default => false
      t.integer :staff_id
      t.boolean :left, :default => false

      t.timestamps
    end
  end
end
