class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :name
      t.integer :status, null: false, default: 0
      t.string  :file

      t.timestamps
    end
    add_index :keywords, [:name, :user_id], unique: true
  end
end
