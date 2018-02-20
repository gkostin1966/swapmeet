class CreatePublishersGroupsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :publishers, :groups do |t|
      t.index [:publisher_id, :group_id]
      t.index [:group_id, :publisher_id]
    end
  end
end
