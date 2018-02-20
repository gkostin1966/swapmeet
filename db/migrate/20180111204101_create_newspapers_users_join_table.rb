class CreateNewspapersUsersJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :newspapers, :users do |t|
      t.index [:newspaper_id, :user_id]
      t.index [:user_id, :newspaper_id]
    end
  end
end
