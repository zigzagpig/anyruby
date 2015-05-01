class AddQqLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :open_id, :string
    add_column :users, :access_token, :string
  end
end
