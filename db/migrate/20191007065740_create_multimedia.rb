class CreateMultimedia < ActiveRecord::Migration[5.1]
  def change
    create_table :multimedia do |t|
    	t.integer :owner
    	t.string :url
    	t.string :type
    	t.boolean :privacy
      t.timestamps
    end
  end
end
