class CreateInsurancerules < ActiveRecord::Migration
  def change
    create_table :insurancerules do |t|
      t.integer :country_id
      t.integer :salary_ceiling, :default => 1000000
      t.boolean :startend_prorate, :default => true
      t.integer :startend_date, :default => 15

      t.timestamps
    end
  end
end
