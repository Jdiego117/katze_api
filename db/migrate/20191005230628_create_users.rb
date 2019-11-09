class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
    	t.boolean :verify
    	t.date :birthdate
    	t.string :name
    	t.string :lastname
    	t.string :nickname
    	t.string :email
    	t.string :country
    	t.string :city
    	t.string :password
    	t.string :profile_pic
    	t.string :description
    	t.boolean :private
      t.timestamps
    end
  end
end
