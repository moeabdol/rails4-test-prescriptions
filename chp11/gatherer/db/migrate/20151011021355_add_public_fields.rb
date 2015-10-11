class AddPublicFields < ActiveRecord::Migration
  def change
    add_column :projects, :public, :boolean, default: false
    add_column :users, :admin, :boolean, default: false
  end
end
