class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
	  t.string :desc
	  t.integer :state
	  t.integer :type
	  t.integer :role_id

      t.timestamps
    end
  end
end
