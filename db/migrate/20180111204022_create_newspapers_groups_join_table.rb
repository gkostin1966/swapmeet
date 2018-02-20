class CreateNewspapersGroupsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :newspapers, :groups do |t|
      t.index [:newspaper_id, :group_id]
      t.index [:group_id, :newspaper_id]
    end
  end
end
