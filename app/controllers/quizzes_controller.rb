class QuizzesController < ApplicationController
    before_action :confirm_logged_in, :except => [:aboutQuizme]
    before_action :is_teacher, :except => [:aboutQuizme]
    
    def show
        @course = session[:current_course]
        @teacher = Teacher.find(params[:id])

        if @course == nil
            @all_courses = Course.where(:teacher => @teacher)
            @student = Student.where(course: @all_courses).where('is_correct = ?', false).where(:roundNumber => session[:round_number]).shuffle.first
            @quizComplete = !Student.where(course: @all_courses).where('is_correct = ?', false).exists?
        else
            @student = Student.where(:course => session[:current_course]).where('is_correct = ?', false).where(:roundNumber => session[:round_number]).shuffle.first
            @quizComplete = !Student.where(:course => session[:current_course]).where('is_correct = ?', false).exists?
        end
        
        if @student == nil && @quizComplete == false
            session[:round_number] += 1
            redirect_to quizzes_endofround_path
        end
        
        if @quizComplete == true
            flash[:notice] = "Quiz complete!"
            redirect_to quizzes_endofquiz_path
        end
    end
    
    def new
        @teacher = Teacher.find(session[:user_id])
        
        @course = session[:current_course]
        
        session[:round_number] = 1
        
        @all_courses = Course.where(:teacher => @teacher)
        @students = Student.where(course: @all_courses)
        @students.each do |student| #this is to differentiate students that are not in the quiz, therefore round 0
            student.update_attribute(:roundNumber, 0)
        end

        if !(@course == nil)
            @students = Student.where(:course => session[:current_course])
        end
        
        @students.each do |student|
            student.update_attribute(:is_correct, false)
            student.update_attribute(:roundNumber, 1)
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
    
    def take_subset_quiz
        @settingRound = params[:id]
        flash[:notice] = @settingRound
        
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
            @student.update_attribute(:roundNumber, session[:round_number] + 1)
            
            
            redirect_to review_quiz_path(@student.id)
        end
        
    end
    
    def review
        @student = Student.find(params[:id])
        @teacher = Teacher.find(session[:user_id])
        session[:current_student] = @student.id
    end
    
    def roundEnd
        @teacher = Teacher.find(session[:user_id])
        @course = session[:current_course]
        
        if @course == nil
            @all_courses = Course.where(:teacher => @teacher)
            @students = Student.where(course: @all_courses)
        else
            @students = Student.where(:course => session[:current_course])
        end
    end
    
    def endPage
        @teacher = Teacher.find(session[:user_id])
        @course = session[:current_course]
        
        if @course == nil
            @all_courses = Course.where(:teacher => @teacher)
            @students = Student.where(course: @all_courses)
        else
            @students = Student.where(:course => session[:current_course])
        end
    end
    
    def about
    end
    
    def aboutQuizme
    end

    def overrideIncorrect
        @student = Student.find(session[:current_student])
        @teacher = Teacher.find(session[:user_id])
        
        @student.update_attribute(:is_correct, true)
        @student.update_attribute(:roundNumber, @student.roundNumber - 1 )
        @student.update_attribute(:quiz_score, @student.quiz_score + 2) # +2 to make up for the erroneous -1 earlier
        @student.update_attribute(:quiz_score_day_updated, Time.now.beginning_of_day.to_i)
        session[:current_student] = nil
        
        redirect_to quiz_path(@teacher.id)
    end
    
    
    
end
