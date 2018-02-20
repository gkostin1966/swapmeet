class CreateNewspapers < ActiveRecord::Migration[5.1]
  def change
    create_table :newspapers do |t|
      t.string :name
      t.string :display_name
      t.belongs_to :publisher, foreign_key: true

      t.timestamps
    end
  end
end
