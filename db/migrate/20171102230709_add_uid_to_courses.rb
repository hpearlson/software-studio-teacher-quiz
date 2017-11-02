class AddUidToCourses < ActiveRecord::Migration
  def change
    add_column "courses", "GeneratedID", :string
  end
end
