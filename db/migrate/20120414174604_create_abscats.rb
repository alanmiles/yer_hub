class CreateAbscats < ActiveRecord::Migration
  def change
    create_table :abscats do |t|
      t.string :category
      t.string :abbreviation
      t.boolean :approved, :default => false
      t.integer :created_by

      t.timestamps
    end
  end
end
