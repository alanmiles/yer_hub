class CreateGratuityrates < ActiveRecord::Migration
  def change
    create_table :gratuityrates do |t|
      t.integer :country_id
      t.integer :service_years_from
      t.integer :service_years_to
      t.integer :resignation_rate
      t.integer :non_resignation_rate

      t.timestamps
    end
  end
end
