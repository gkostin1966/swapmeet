class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :display_name
      t.references :parent, index: true

      t.timestamps
    end
  end
end
