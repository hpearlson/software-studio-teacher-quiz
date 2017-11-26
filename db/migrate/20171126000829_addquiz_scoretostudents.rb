class AddquizScoretostudents < ActiveRecord::Migration
  def change
    add_column "students", "quiz_score", :integer
  end
end
