class CoursesController < ApplicationController
    
    
    def index
        @courses = Course.all
    end
    
	def show 
  	    @course = Course.find(params[:id]) 
  	    @students = Student.all.where(:course => @course)
  	    flash[:page] = 1
  	    session[:current_course] = @course.id
	end
    
    def new
       @couse = Course.new 
    end
    
    def create
        @course = Course.new(course_params)
        if @course.save
            flash[:notice] = "#{@course.course_name} was successfully created."
        else
            flash[:warning] = "Course could not be created because #{@course.errors.full_messages}"
        end
        redirect_to courses_path
    end
    
    def edit
       @course = Course.find params[:id] 
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
        @course.destroy
        flash[:notice] = "#{@course.course_name} was successfully deleted"
        redirect_to courses_path
    end
    
    private
    
    def course_params
        params.require(:course).permit(:course_name, :student_list)
    end

end
