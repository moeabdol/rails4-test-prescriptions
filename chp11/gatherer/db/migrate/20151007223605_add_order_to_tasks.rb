class AddOrderToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :project_order, :integer
  end
end
