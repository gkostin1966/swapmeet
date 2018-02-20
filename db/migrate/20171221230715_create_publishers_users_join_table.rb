class CreatePublishersUsersJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :publishers, :users do |t|
      t.index [:publisher_id, :user_id]
      t.index [:user_id, :publisher_id]
    end
  end
end
