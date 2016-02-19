class PostUser < ActiveRecord::Migration
  def change
    add_reference :posts, :user, references: :users, index: true
    add_foreign_key :posts, :users, column: :user_id
  end
end
