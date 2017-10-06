class Course < ActiveRecord::Base
    
    def initialize(course_name, teacher_id=1, student_list=[])
        @course_name = course_name
        @teacher_id = teacher_id
        @student_list = student_list
    end
    
    def add_student(student_id)
        @student_list.push(student_id)
    end
    
    def del_student(student_id)
       @student_list.delete(student_id) 
    end
    
    def display_students
        puts "Here is where the student will be!"
    end
end
