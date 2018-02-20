class CreateGatekeepers < ActiveRecord::Migration[5.1]
  def change
    create_table :gatekeepers do |t|
      t.string :role
      t.references :domain, foreign_key: true
      t.references :group, foreign_key: true
      t.references :listing, foreign_key: true
      t.references :newspaper, foreign_key: true
      t.references :publisher, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
