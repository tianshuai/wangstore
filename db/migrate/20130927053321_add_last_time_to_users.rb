class AddLastTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_time, :datetime
  end
end
