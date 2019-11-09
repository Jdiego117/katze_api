class CreateVerifies < ActiveRecord::Migration[5.1]
  def change
    create_table :verifies do |t|
    	t.string :code
    	t.integer :user_id
      t.timestamps
    end
  end
end
