class TeachersController < ApplicationController
    
    def index
        @teachers = Teacher.all
    end
    
    def show
        @teacher = Teacher.find(params[:id])
    end
    
    def create
        @teacher = Teacher.new(teacher_params)
        if @teacher.save
            flash[:notice] = "#{@teacher.first_name} was successfully created."
            redirect_to teachers_path
        else
            flash[:notice] = "Something went wrong."
            redirect_to '/teachers/new'
        end
    end
    
    def destroy
        @teacher = Teacher.find params[:id]
        @teacher.destroy
        flash[:notice] = "#{@teacher.username} was successfully deleted"
        redirect_to teachers_path
    end
    
    def edit
       @student = Teacher.find params[:id] 
       #@courses = Course.all
    end
    
    def new
       @teacher = Teacher.new
    end
    
    private
    
    def teacher_params
        params.require(:teacher).permit(:username, :first_name, :last_name, :description, :image, :password_digest, :password)
    end
end
