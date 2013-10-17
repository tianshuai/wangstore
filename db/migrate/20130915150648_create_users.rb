class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name,		null: false
      t.string :email,		null: false
	  t.text :description
	  t.integer :state,		null: false,	default: 1
	  t.integer :kind,		null: false,	default: 1
	  t.integer :role_id,	null: false,	default: 1
	  t.integer :sex,		null: false,	default: 0
	  t.string :ip
	  t.datetime :last_time
	  t.string :remember_token
	  t.string :password_digest
	  t.string :avatar_path
	  t.string :avatar_format

      t.timestamps
    end

	add_index :users,	:email, unique: true
	add_index :users,	:name,	unique: true
	add_index :users,	:role_id
    add_index :users, 	:remember_token
    add_index :users, 	:last_time
	add_index :users,	:kind
	add_index :users,	:avatar_path
  end
end
