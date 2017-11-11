class QuizzesController < ApplicationController
    
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
            redirect_to students_path
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
        
        redirect_to quiz_path(@teacher.id)
    end
    
    def check_answer
        @teacher = Teacher.find(params[:id])
        @check = params[:student].to_s.split('=>')
        @check2 = @check[1].split('"')
        @name = @check2[1]
        @student = Student.find(params[:student_id])
        if @student.full_name == @name
            flash[:correct] = "Correct!"
            @student.update_attribute(:is_correct, true)
            redirect_to quiz_path(@teacher.id)
            
        else
            flash[:correct] = "Incorrect!"
            redirect_to review_quiz_path(@student.id)
        end
        
    end
    
    def review
        @student = Student.find(params[:id])
        @teacher = Teacher.find(session[:user_id])
    end
end
