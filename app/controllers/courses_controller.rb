class CoursesController < ApplicationController
    
    
    def index
        @courses = Course.all 
    end
    
    
    def new
       @couse = Course.new 
    end
    
    def create
        @course = Course.create!(course_params)
        flash[:notice] = "#{@course.course_name} was successfully created."
        redirect_to courses_path
    end
    
    def course_params
        params.require(:course).permit(:course_name, :teacher_id, :student_list)
    end
    
	def show 
  	    @course = Course.find(params[:id]) 
  	    @students = @course.students 
	end
end
