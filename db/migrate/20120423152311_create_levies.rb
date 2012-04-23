class CreateLevies < ActiveRecord::Migration
  def change
    create_table :levies do |t|
      t.integer :country_id
      t.string :name
      t.integer :low_salary
      t.integer :high_salary
      t.decimal :employer_nats, :precision => 4, :scale => 2, :default => 0
      t.decimal :employer_expats, :precision => 4, :scale => 2, :default => 0
      t.decimal :employee_nats, :precision => 4, :scale => 2, :default => 0
      t.decimal :employee_expats, :precision => 4, :scale => 2, :default => 0

      t.timestamps
    end
  end
end
