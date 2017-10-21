class CoursesController < ApplicationController
    
    
    def index
        @courses = Course.all 
    end
    
	def show 
  	    @course = Course.find(params[:id]) 
  	    @students = Student.all.where(:course => @course)
	end
    
    def new
       @couse = Course.new 
    end
    
    def create
        @course = Course.create!(course_params)
        flash[:notice] = "#{@course.course_name} was successfully created."
        redirect_to courses_path
    end
    
    def edit
       @course = Course.find params[:id] 
    end
    
    def update
       @course = Course.find params[:id]
       @course.update_attributes!(course_params)
       flash[:notice] = "#{@course.course_name} was successfully updated."
       redirect_to course_path(@course)
    end
    
    def destroy
        @course = Course.find params[:id]
        @course.destroy
        flash[:notice] = "#{@course.course_name} was successfully deleted"
        redirect_to courses_path
    end
    
    private
    
    def course_params
        params.require(:course).permit(:course_name, :teacher_id, :student_list)
    end

end
