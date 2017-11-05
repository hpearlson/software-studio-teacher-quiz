class AddGeneratedIdToStudents < ActiveRecord::Migration
  def change
    add_column "students", "generatedID", :string
  end
end
