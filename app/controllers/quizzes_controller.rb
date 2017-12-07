class QuizzesController < ApplicationController
    before_action :confirm_logged_in, :except => [:aboutQuizme]
    before_action :is_teacher, :except => [:aboutQuizme]
    
    def show
        @course = session[:current_course]
        @teacher = Teacher.find(params[:id])

        if @course == nil
            @all_courses = Course.where(:teacher => @teacher)
            @student = Student.where(course: @all_courses).where('is_correct = ?', false).shuffle.first
        else
            @student = Student.where(:course => session[:current_course]).where('is_correct = ?', false).shuffle.first
        end
        
        if @student == nil
            flash[:notice] = "Quiz complete!"
            if @course == nil
                redirect_to students_path
            else
                redirect_to course_path(@course)
            end
        end
        
    end
    
    def new
        @teacher = Teacher.find(session[:user_id])
        
        @course = session[:current_course]

        if @course == nil
            @all_courses = Course.where(:teacher => @teacher)
            @students = Student.where(course: @all_courses)
        else
            @students = Student.where(:course => session[:current_course])
        end
        
        @students.each do |student|
            student.update_attribute(:is_correct, false)
        end
        
        if session[:quiz_type] == "behind"
            
            @otherStudents = Student.where("quiz_score > ?", 0)
            @otherStudents.each do |student|
                student.update_attribute(:is_correct, true)
            end
            session[:quiz_type] = "normal"
        end
        
        redirect_to quiz_path(@teacher.id)
    end
    
    def take_remedial_quiz
        session[:quiz_type] = "behind"
        redirect_to new_quiz_path
    end


    def check_answer
        @teacher = Teacher.find(params[:id])
        @check = params[:student].to_s.split('=>')
        @check2 = @check[1].split('"')
        @name = @check2[1]
        @student = Student.find(params[:student_id])
        if @student.full_name == @name
            flash[:correctAnswer] = "Correct!"
            @student.update_attribute(:is_correct, true)
            @student.update_attribute(:quiz_score, @student.quiz_score + 1)
            @student.update_attribute(:quiz_score_day_updated, Time.now.beginning_of_day.to_i)
            redirect_to review_quiz_path(@student.id)
            
        else
            flash[:incorrectAnswer] = "Incorrect!"
            @student.update_attribute(:quiz_score, @student.quiz_score - 1)
            @student.update_attribute(:quiz_score_day_updated, Time.now.beginning_of_day.to_i)
            redirect_to review_quiz_path(@student.id)
        end
        
    end
    
    def review
        @student = Student.find(params[:id])
        @teacher = Teacher.find(session[:user_id])
    end
    
    def about
    end
    
    def aboutQuizme
    end
end
