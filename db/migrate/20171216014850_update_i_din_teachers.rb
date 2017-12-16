class UpdateIDinTeachers < ActiveRecord::Migration
  def change
    change_column "students", "true_id", :integer, limit: 8
  end 
end
