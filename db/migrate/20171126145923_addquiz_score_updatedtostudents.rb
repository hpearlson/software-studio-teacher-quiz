class AddquizScoreUpdatedtostudents < ActiveRecord::Migration
  def change
    add_column "students", "quiz_score_day_updated", :integer
  end
end