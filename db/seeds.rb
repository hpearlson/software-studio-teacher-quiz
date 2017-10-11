courses = [
    {:course_name => 'Intro to Computer Science', :teacher_id => 1, :student_list => 1},
    {:course_name => 'Software Studio', :teacher_id => 2, :student_list => 2}
]

courses.each do |course|
    Course.create!(course)
end