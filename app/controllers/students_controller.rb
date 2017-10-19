class StudentsController < ApplicationController
    
    def index
        @students = Student.all 
    end

    def show
       @student = Student.find(params[:id])
       @next = Student.where(:course => @student.course).where.not(:id => @student.id).take
    end

    def create
        @student = Student.create!(student_params)
        flash[:notice] = "#{@student.first_name} was successfully created."
        redirect_to students_path
    end

    def new
       @student = Student.new
       @courses = Course.all
    end
    
    def destroy
        @student = Student.find params[:id]
        @student.destroy
        flash[:notice] = "#{@student.first_name} was successfully deleted"
        redirect_to students_path
    end
    
    private
    
    def student_params
        params.require(:student).permit(:first_name, :last_name, :description, :image, :course_id)
    end
end
