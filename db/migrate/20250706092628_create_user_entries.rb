class CreateUserEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :user_entries do |t|
      t.datetime :date
      t.integer :distance
      t.integer :time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_entries, [:user_id, :date]
  end


end
