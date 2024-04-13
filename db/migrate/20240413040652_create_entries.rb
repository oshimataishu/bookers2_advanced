class CreateEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :entries do |t|
      t.references :user_id, foreign_key: true
      t.references :room_id, foreign_key: true
      t.timestamps
    end
  end
end
