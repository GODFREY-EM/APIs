class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :species
      t.string :breed
      t.float :age
      t.integer :owner_id

      t.timestamps
    end
  end
end
