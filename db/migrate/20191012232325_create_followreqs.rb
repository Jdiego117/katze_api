class CreateFollowreqs < ActiveRecord::Migration[5.1]
  def change
    create_table :followreqs do |t|
    	t.integer :userReq
    	t.integer :target
      t.timestamps
    end
  end
end
