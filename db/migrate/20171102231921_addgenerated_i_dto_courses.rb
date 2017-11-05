class AddgeneratedIDtoCourses < ActiveRecord::Migration
  def change
    add_column "courses", "generatedID", :string
  end
end
