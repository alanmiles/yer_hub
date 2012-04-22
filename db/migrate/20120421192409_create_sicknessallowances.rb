class CreateSicknessallowances < ActiveRecord::Migration
  def change
    create_table :sicknessallowances do |t|
      t.integer :country_id
      t.integer :sick_days_from
      t.integer :sick_days_to
      t.integer :deduction_rate			#% of salary and selected benefits to be deducted

      t.timestamps
    end
  end
end
