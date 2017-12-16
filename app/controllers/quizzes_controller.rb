##
#This class handles quiz functionality. Methods in this class
#interact with student and teacher objects.
class QuizzesController < ApplicationController
    before_action :confirm_logged_in, :except => [:aboutQuizme]
    before_action :is_teacher, :except => [:aboutQuizme]
    
    ##
    #This method displays a random student from the pool of students
    #that is being quized on.
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
    
    ##
    #This method sets up a new quiz for a given teacher.
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
    
    ##
    #If a teacher chooses to quiz only unfamiliar students,
    #this method records that choice before the quiz is set up.
    def take_remedial_quiz
        session[:quiz_type] = "behind"
        redirect_to new_quiz_path
    end
    
    ##
    #If a teacher chooses to replay a certain round,
    #this method records which round they're replaying from
    #and flags it. It then redirects to the "new" method
    #to reset the quiz.
    def take_subset_quiz
        @settingRound = params[:id]
        flash[:notice] = @settingRound
        
        redirect_to new_quiz_path
    end
    
    
    ##
    #Once a teacher answers a question on the quiz,
    #this method evaluates their answer, records it in the database,
    #and redirects them to the appropriate page.
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
    
    ##
    #If the teacher gets a student's name wrong, they're sent to a review page
    #handled by this method. The review page shows them the correct answer
    #and prompts them to move on when ready.
    def review
        @student = Student.find(params[:id])
        @teacher = Teacher.find(session[:user_id])
        session[:current_student] = @student.id
    end
    
    ##
    #At the end of a round, the teacher is taken to this page,
    #which shows which of the students' names they got correct,
    #and prompts them to move on.
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
    
    ##
    #Once the teacher has gotten all students' names correct,
    #they are taken to this page, which shows them the outcomes
    #from all of the rounds and allows them to either retake the
    #quiz from a different round or finish the quiz.
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
    
    ##
    #This page has information about the quizzes and how they work.
    def about
    end
    
    ##
    #This page has information about QuizMe
    #for people who are new to the site.
    def aboutQuizme
    end

    ##
    #If a teacher presses the "Override: I was right" button on the review
    #page, this method will record that in the database and redirect them
    #to the next page in the quiz.
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
