class AddBcolorToStories < ActiveRecord::Migration[5.1]
  def change
    add_column :stories, :bcolor, :string
  end
end
