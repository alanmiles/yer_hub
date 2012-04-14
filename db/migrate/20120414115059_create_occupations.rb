class CreateOccupations < ActiveRecord::Migration
  def change
    create_table :occupations do |t|
      t.string :occupation
      t.boolean :approved, :default => false
      t.integer :created_by

      t.timestamps
    end
  end
end
