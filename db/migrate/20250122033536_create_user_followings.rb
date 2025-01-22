class CreateUserFollowings < ActiveRecord::Migration[8.0]
  def change
    create_table :user_followings do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }, index: true
      t.references :followed_user, null: false, foreign_key: { to_table: :users }, index: true
      t.timestamps
    end

    add_index :user_followings, [:user_id, :followed_user_id], unique: true
  end
end
