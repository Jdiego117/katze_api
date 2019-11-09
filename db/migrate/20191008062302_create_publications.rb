class CreatePublications < ActiveRecord::Migration[5.1]
  def change
    create_table :publications do |t|
    	t.boolean :private
    	t.integer :author
    	t.string :text
    	t.string :content_url
    	t.string :tags
    	t.string :hashtags
      t.timestamps
    end
  end
end
