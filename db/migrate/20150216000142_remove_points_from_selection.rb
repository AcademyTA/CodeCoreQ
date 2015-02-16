class RemovePointsFromSelection < ActiveRecord::Migration
  def change
    remove_column :selections, :points, :integer
  end
end
