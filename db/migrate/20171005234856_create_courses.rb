class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :course_name
      t.integer :teacher_id
      t.integer :student_list
      t.timestamps
    end
  end
end
