class StudentsController < ApplicationController
    
    def index
        @students = Student.all 
    end

    def show
       @student = Student.find(params[:id])
    end

    def create
        @student = Student.create!(student_params)
        flash[:notice] = "#{@student.first_name} was successfully created."
        redirect_to students_path
    end

    def new
       @student = Student.new 
    end
    
    def student_params
        params.require(:student).permit(:first_name, :last_name, :description, :course, :student_id, :image)
    end
end
