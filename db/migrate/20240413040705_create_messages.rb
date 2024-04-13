class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :room_id, foreign_key: true
      t.references :user_id, foreign_key: true
      t.text :content
      t.timestamps
    end
  end
end
