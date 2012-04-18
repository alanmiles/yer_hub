class CreateInsurancerates < ActiveRecord::Migration
  def change
    create_table :insurancerates do |t|
      t.integer :country_id
      t.integer :low_salary
      t.integer :high_salary
      t.integer :employer_nats
      t.integer :employer_expats
      t.integer :employee_nats
      t.integer :employee_expats
      t.integer :position

      t.timestamps
    end
  end
end
