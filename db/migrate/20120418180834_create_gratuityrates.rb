class CreateGratuityrates < ActiveRecord::Migration
  def change
    create_table :gratuityrates do |t|
      t.integer :country_id
      t.integer :service_years_from
      t.integer :service_years_to
      t.decimal :resignation_rate, :precision => 5, :scale => 2
      t.decimal :non_resignation_rate, :precision => 5, :scale => 2

      t.timestamps
    end
  end
end
