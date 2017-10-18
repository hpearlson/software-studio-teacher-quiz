=begin
courses = [
    {:course_name => 'Intro to Computer Science', :teacher_id => 1, :student_list => 1},
    {:course_name => 'Software Studio', :teacher_id => 2, :student_list => 2}
]

courses.each do |course_name, teacher_id, student_list|
    Course.create!(course_name: course, teacher_id: teacher_id, student_list: student_list)
end

=end


Student.create(first_name: "Mitty", last_name: "Smitty", description: "A sophomore Finance major", image: "https://previews.123rf.com/images/karelnoppe/karelnoppe1505/karelnoppe150500027/39759459-Close-up-portrait-Successful-businessman-pulling-a-fist-Young-business-student-with-victorious-facia-Stock-Photo.jpg")

