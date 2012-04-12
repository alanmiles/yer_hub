class CreateNationalities < ActiveRecord::Migration
  def change
    create_table :nationalities do |t|
      t.string :nationality

      t.timestamps
    end
  end
end
