class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string :sector
      t.boolean :approved, :default => false
      t.integer :created_by

      t.timestamps
    end
  end
end
