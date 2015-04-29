class AddConnectToArticles < ActiveRecord::Migration
  def change
    add_reference :articles, :user, index: true
    add_foreign_key :articles, :users
    add_index :articles, [:user_id, :created_at]
  end
end
