class AddRoundNumberToStudents < ActiveRecord::Migration
  def change
    add_column "students", "roundNumber", :integer
  end
end
