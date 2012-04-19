class CreateInsurancerates < ActiveRecord::Migration
  def change
    create_table :insurancerates do |t|
      t.integer :country_id
      t.integer :low_salary
      t.integer :high_salary
      t.decimal :employer_nats, :precision => 4, :scale => 2
      t.decimal :employer_expats, :precision => 4, :scale => 2
      t.decimal :employee_nats, :precision => 4, :scale => 2
      t.decimal :employee_expats, :precision => 4, :scale => 2 
      t.integer :position

      t.timestamps
    end
  end
end
