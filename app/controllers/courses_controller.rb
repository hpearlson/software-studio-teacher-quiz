class CoursesController < ApplicationController
    def index
        @courses = Course.all 
    end
    
    def show
       @course = Course.find(params[:id])
    end
    
    def new
       @couse = Course.new 
    end
    
    def create
        @course = Course.create!(course_params)
        flash[:notice] = "#{@course.title} was successfully created."
        redirect_to courses_path
    end
    
    def course_params
        params.require(:course).permit(:course_name, :teacher_id, :student_list)
    end
end
