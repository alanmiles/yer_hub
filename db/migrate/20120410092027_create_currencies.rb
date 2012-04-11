class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :currency
      t.string :abbreviation
      t.integer :dec_places
      t.decimal :change_to_dollars, :precision => 8, :scale => 5
      t.boolean :approved, :default => false
      t.integer :created_by
      
      t.timestamps
    end
  end
end
