class AddPtypeToPublications < ActiveRecord::Migration[5.1]
  def change
    add_column :publications, :ptype, :string
  end
end
