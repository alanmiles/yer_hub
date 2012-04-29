class CreateEntabsencedefs < ActiveRecord::Migration
  def change
    create_table :entabsencedefs do |t|
      t.integer :enterprise_id
      t.string :category
      t.string :abbreviation
      t.string :description
      t.integer :max_per_year
      t.integer :salary_deduction, :default => 0
      t.boolean :sickness, :default => false
      t.boolean :push, :default => false
      t.boolean :inactive, :default => false
      t.integer :updated_by

      t.timestamps
    end
  end
end
