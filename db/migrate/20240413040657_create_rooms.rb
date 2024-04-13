class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.references :user_id, foreign_key: true

      t.timestamps
    end
  end
end
