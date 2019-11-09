class CreatePtags < ActiveRecord::Migration[5.1]
  def change
    create_table :ptags do |t|
    	t.integer :author
    	t.integer :target
    	t.string :tag_type
    	t.integer :content
      t.timestamps
    end
  end
end
