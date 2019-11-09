class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
    	t.integer :author
    	t.integer :target
    	t.string :target_type
      t.timestamps
    end
  end
end
