class StudentsController < ApplicationController  
    
    before_action :confirm_logged_in, :except => [:signup, :new, :register]
    before_action :is_teacher, :except => [:show, :edit, :update, :signup, :register]

    def index
        @teacher = Teacher.find(session[:user_id])
        @courses = Course.where(:teacher => @teacher)
        @students = Student.all.where(course: @courses).order(:last_name).page(params[:page])
        Student.apply_spaced_repetition(session[:user_id])
        session.delete(:current_course)
    end

    def show
        @student = Student.find(params[:id])
        if session[:user_type] == "Teacher"
            if Teacher.find(session[:user_id]) != @student.course.teacher
  	            flash[:notice] = "Access Denied"
  	            redirect_to courses_path
  	        end
  	        @class = nil
  	        @edit_button = "button"
  	        @delete_button = "button caution"
  	    elsif session[:user_type] == "Student"
  	        @class = "hidden"
  	        @course = @student.course
  	        if @student.course != Student.find(session[:user_id]).course
  	            flash[:notice] = "Access Denied"
  	            redirect_to course_path(Student.find(session[:user_id]).course_id)
  	        end
  	        if Student.find(session[:user_id]) != @student
  	            @edit_button = "hidden"
  	            @delete_button = "hidden"
  	        else
  	            @edit_button = "button"
  	            @delete_button = "button caution"
  	        end
  	    end
  	    @button_class = "title-bar-button"
    end

    def create
        @student = Student.new(student_params)
        @student.quiz_score = 0
        @student.quiz_score_day_updated = Time.now.beginning_of_day.to_i
        if @student.save
            flash[:notice] = "#{@student.first_name} was successfully created."
        else
            flash[:notice] = "Student could not be created because #{@student.errors.full_messages}"
        end
        redirect_to students_path
    end

    def new
       @student = Student.new
       @teacher = Teacher.find(session[:user_id])
       @courses = Course.where(:teacher => @teacher)
    end
    
    def signup
       @student = Student.new
       @courses = Course.all
    end
    
    def register
        @student = Student.new(student_params)
        @local_course = Course.where(:generatedID => @student.generatedID).take
        @student.course_id = @local_course.id
        if @student.save
            flash[:notice] = "#{@student.first_name} was  created."
        else
            flash[:notice] = "Student could not be created because #{@student.errors.full_messages}"
        end
        redirect_to '/home'
    end

    
    def destroy
        @student = Student.find params[:id]
        @student.destroy
        flash[:notice] = "#{@student.first_name} was successfully deleted"
        redirect_to students_path
    end
    
    def edit
       @student = Student.find params[:id]
       @courses = Course.all
       if session[:user_type] == "student"
           if Student.find(session[:user_id]) != @student
               flash[:notice] = "Access Denied"
               redirect_to student_path(@student)
           end
       end
    end
    
    def update
       @student = Student.find(params[:id])
       if @student.update_attributes(student_params)
           flash[:notice] = "#{@student.first_name} #{@student.last_name} was successfully updated."
       else
           flash[:warning] = "#{@student.first_name} #{@student.last_name} could not be updated because #{@student.errors.full_messages}"
       end
       redirect_to student_path(@student)
    end
    
    private
    
    def student_params
        params.require(:student).permit(:username, :password, :password_digest, :password_confirmation,
                        :first_name, :last_name, :description, :image, :course_id, :generatedID, :email_address)
    end
    
    def confirm_logged_in
        unless session[:user_id]
          flash[:notice] = "Please log in."
          redirect_to(access_login_path)
        end
    end
end
