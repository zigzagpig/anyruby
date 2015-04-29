class CreateMiniQuoras < ActiveRecord::Migration
  def change
    create_table :mini_quoras do |t|
      t.text :question
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :mini_quoras, :users
  end
end
