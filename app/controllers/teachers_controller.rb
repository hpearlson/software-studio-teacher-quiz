class TeachersController < ApplicationController
    
    def index
        @teachers = Teacher.all
    end
    
    def create
        @teacher = Teacher.create!(teacher_params)
        flash[:notice] = "#{@teacher.first_name} was successfully created."
        redirect_to teachers_path
    end
    
    def new
       @teacher = Teacher.new
    end
    
    private
    
    def teacher_params
        params.require(:teacher).permit(:username, :first_name, :last_name, :description, :image, :password_digest)
    end
end
