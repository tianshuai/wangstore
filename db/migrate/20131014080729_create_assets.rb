class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
	  t.string :description
	  t.string :source_path
	  t.string :file_path,			null: false
	  t.string :file_name,			null: false
	  t.integer :size,				null: false,	default: 0
	  t.integer :state,				null: false,	default: 1
	  t.integer :sort,				null: false,	default: 0
	  t.integer :kind,				null: false,	default: 1
	  t.integer :width,				null: false,	default: 0
	  t.integer :height,			null: false,	default: 0
	  t.string :format_type,		null: false
	  t.integer :relateable_id
	  t.string :relateable_type

      t.timestamps
    end

	#索引
    add_index :assets, :name
    add_index :assets, :size
    add_index :assets, :sort
    add_index :assets, :kind
    add_index :assets, :relateable_id
    add_index :assets, :relateable_type
  end
end
