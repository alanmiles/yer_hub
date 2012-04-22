class CreateLegislations < ActiveRecord::Migration
  def change
    create_table :legislations do |t|
      t.integer :country_id
      t.integer :retirement_men, :default => 65
      t.integer :retirement_women, :default => 60
      t.boolean :sickness_accruals, :default => false
      t.integer :max_sickness_accrual, :default => 0
      t.integer :probation_days, :default => 90

      t.timestamps
    end
  end
end
