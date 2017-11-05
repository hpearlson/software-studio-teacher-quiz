class CoursesController < ApplicationController

    before_action :confirm_logged_in
    
    def index
        @teacher = Teacher.find(session[:user_id])
        @courses = Course.where(:teacher => @teacher)
    end
    
	def show
  	    @course = Course.find(params[:id]) 
  	    #if Teacher.find(session[:user_id]) != @course.teacher
  	     #   flash[:notice] = "Access Denied"
  	      #  redirect_to courses_path
  	    #end
  	    @students = Student.where(:course => @course)
  	    session[:current_course] = @course.id
	end
    
    def new
        @teacher = Teacher.where(:username => session[:username]).take
        @couse = Course.new 
    end
    
    def create
        params[:course][:teacher_id] = session[:user_id] 
        @course = Course.new(course_params)
        @course.generatedID = 16.times.map{rand(10)}.join
        #@teacher = Teacher.find(session[:user_id])
        #@course.teacher = @teacher
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
