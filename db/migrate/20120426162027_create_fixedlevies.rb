class CreateFixedlevies < ActiveRecord::Migration
  def change
    create_table :fixedlevies do |t|
      t.integer :country_id
      t.string :name
      t.integer :low_salary
      t.integer :high_salary
      t.decimal :employer_nats, :precision => 7, :scale => 3, :default => 0
      t.decimal :employer_expats, :precision => 7, :scale => 3, :default => 0
      t.decimal :employee_nats, :precision => 7, :scale => 3, :default => 0
      t.decimal :employee_expats, :precision => 7, :scale => 3, :default => 0

      t.timestamps
    end
  end
end
