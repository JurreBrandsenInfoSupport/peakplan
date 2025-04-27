class AddOwnerToProject < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :owner, :string, null: false
    add_column :tasks, :owner, :string, null: false
  end
end
