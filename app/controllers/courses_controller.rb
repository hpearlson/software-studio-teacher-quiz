class CoursesController < ApplicationController

    before_action :confirm_logged_in
    before_action :is_teacher, :except => [:show]
    
    def index
        @teacher = Teacher.find(session[:user_id])
        @courses = Course.where(:teacher => @teacher).page(params[:page])
        Student.apply_spaced_repetition(session[:user_id])
    end
    
	def show
  	    @course = Course.find(params[:id]) 
  	    @page_title = "Quizme - " + @course.course_name
  	    if session[:user_type] == "Teacher"
  	        if Teacher.find(session[:user_id]) != @course.teacher
  	            flash[:notice] = "Access Denied"
  	            redirect_to courses_path
  	        end
  	        @button_class = "title-bar-button"
  	        @quiz_button = "quiz-button"
  	        @course_id_box = "course-id-box"
  	    elsif session[:user_type] == "Student"
  	        if Student.find(session[:user_id]).course != @course
  	            flash[:notice] = "Access Denied"
  	            redirect_to students_path
  	        end
  	        @button_class = "hidden"
  	        @quiz_button = "hidden"
  	        @course_id_box = "hidden"
  	        
  	    else
  	        flash[:notice] = "Access Denied"
  	        redirect_to "/"
  	    end
  	    @students = Student.where(:course => @course).page(params[:page])
  	    session[:current_course] = @course.id
  	    
  	    respond_to do |format|
            format.html
            format.csv { send_data @students.to_csv }
        end
	end
    
    def new
        @teacher = Teacher.where(:username => session[:username]).take
        @couse = Course.new 
    end
    
    def create
        params[:course][:teacher_id] = session[:user_id] 
        @course = Course.new(course_params)
        @course.generatedID = Time.now.to_i.to_s
        @teacher = Teacher.find(session[:user_id])
        @course.teacher = @teacher
        if @course.save
            flash[:notice] = "#{@course.course_name} was successfully created."
        else
            flash[:notice] = "Course could not be created because #{@course.errors.full_messages}"
        end
        redirect_to courses_path
    end
    
    def edit
       @course = Course.find params[:id] 
       @teacher = @course.teacher
    end
    
    def update
       @course = Course.find params[:id]
       if @course.update_attributes(course_params)
           flash[:notice] = "#{@course.course_name} was successfully updated."
       else
           flash[:warning] = "#{@course.course_name} could not be updated because #{@course.errors.full_messages}"
       end
       redirect_to course_path(@course)
    end
    
    def destroy
        @course = Course.find params[:id]
        @students = Student.where(:course => @course)
        @course.destroy
        @students.each do |student|
            student.destroy
        end
        flash[:notice] = "#{@course.course_name} was successfully deleted"
        redirect_to courses_path
    end
    
    private
    
    def course_params
        params.require(:course).permit(:course_name, :teacher_id)
    end
    
    def confirm_logged_in
        unless session[:user_id]
            flash[:notice] = "Please log in."
            redirect_to(access_login_path)
        end
    end

end
