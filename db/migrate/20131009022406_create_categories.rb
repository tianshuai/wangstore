class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string 	:name,		null: false
	  t.string 	:description
	  t.integer :user_id,	null: false
      t.integer :kind,		null: false, default: 1
      t.integer :state,		null: false, default: 1
      t.integer :stick,		null: false, default: 0
	  t.integer :pid,		null: false, default: 0
	  t.integer :sort,		null: false, default: 0
	  t.integer :count,		null: false, default: 0

      t.timestamps
    end
    add_index :categories, :user_id
	add_index :categories, :kind
    add_index :categories, :name
	add_index :categories, :pid
	add_index :categories, :sort
  end
end
