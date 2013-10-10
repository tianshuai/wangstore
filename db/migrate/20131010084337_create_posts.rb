class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title,			null: false
      t.text :description
	  t.text :content
	  t.integer :user_id,		null: false
	  t.integer :kind,			null: false, default: 1
	  t.integer :category_id,	null: false
	  t.integer :state,			null: false, default: 1
	  t.integer :publish,		null: false, default: 1
	  t.integer :view_count,	null: false, default: 0
	  t.integer :stick,			null: false, default: 0
	  t.integer :sort,			null: false, default: 0
	  t.integer :asset_id

      t.timestamps
    end
    add_index :posts, :user_id
	add_index :posts, :kind
    add_index :posts, :title
	add_index :posts, :view_count
	add_index :posts, :sort
	add_index :posts, :category_id
  end
end

