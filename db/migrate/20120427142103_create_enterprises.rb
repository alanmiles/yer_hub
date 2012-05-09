class CreateEnterprises < ActiveRecord::Migration
  def change
    create_table :enterprises do |t|
      t.string :name
      t.string :short_name
      t.integer :company_registration
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.string :town
      t.string :district
      t.string :zipcode
      t.integer :country_id
      t.string :home_airport
      t.string :sector_id
      t.text :mission
      t.text :values
      t.boolean :terms_accepted, :default => false
      t.integer :setup_step, :default => 1
      t.boolean :inactive, :default => false
      t.integer :created_by

      t.timestamps
    end
  end
end
