class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :country
      t.integer :nationality_id
      t.integer :currency_id

      t.timestamps
    end
  end
end
