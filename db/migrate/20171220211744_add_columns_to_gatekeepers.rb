class AddColumnsToGatekeepers < ActiveRecord::Migration[5.1]
  def change
    add_column :gatekeepers, :role_type, :string
    add_column :gatekeepers, :role_id, :string
    add_column :gatekeepers, :subject_type, :string
    add_column :gatekeepers, :subject_id, :string
    add_column :gatekeepers, :verb_type, :string
    add_column :gatekeepers, :verb_id, :string
    add_column :gatekeepers, :object_type, :string
    add_column :gatekeepers, :object_id, :string
  end
end
