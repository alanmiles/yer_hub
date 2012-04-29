class CreateBizparameters < ActiveRecord::Migration
  def change
    create_table :bizparameters do |t|
      t.integer :business_id
      t.decimal :daily_salary_rate, :precision => 4, :scale => 2, :default => 30
      t.decimal :hourly_salary_rate, :precision => 5, :scale => 2, :default => 176
      t.decimal :ot_multiplier_1, :precision => 3, :scale => 2, :default => 1.25
      t.decimal :ot_multiplier_2, :precision => 3, :scale => 2, :default => 1.5
      t.decimal :ot_multiplier_3, :precision => 3, :scale => 2, :default => 2
      t.integer :standard_weekend_1, :default => 6
      t.integer :standard_weekend_2, :default => 7
      t.boolean :vacation_calculation, :default => false
      t.integer :payroll_close, :default => 15
      t.boolean :push_changes, :default => false

      t.timestamps
    end
  end
end
