class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :course_name
      t.integer :teacher_id
      t.array :student_list
      t.timestamps null: false
    end
  end
end
