class AddLocationToUserEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :user_entries, :location, :string
  end
end
