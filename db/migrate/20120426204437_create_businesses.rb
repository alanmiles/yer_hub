class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.integer :enterprise_id
      t.string :business_name
      t.string :short_name
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :town
      t.string :district
      t.string :zipcode
      t.integer :country_id
      t.string :home_airport
      t.integer :sector_id
      t.text :mission
      t.text :values
      t.boolean :share_mission, :default => false
      t.integer :setup_step, :default => 1
      t.boolean :inactive, :default => false

      t.timestamps
    end
  end
end
