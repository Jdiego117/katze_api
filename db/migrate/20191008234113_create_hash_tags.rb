class CreateHashTags < ActiveRecord::Migration[5.1]
  def change
    create_table :hash_tags do |t|
    	t.string :name
    	t.integer :author
      t.timestamps
    end
  end
end
