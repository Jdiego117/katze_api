class CreateStories < ActiveRecord::Migration[5.1]
  def change
    create_table :stories do |t|
    	t.integer :author
    	t.boolean :private
    	t.string :text
    	t.string :content_url
    	t.string :hashtags
    	t.string :ptype
      t.timestamps
    end
  end
end
