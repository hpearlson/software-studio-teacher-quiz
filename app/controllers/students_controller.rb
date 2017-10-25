class StudentsController < ApplicationController
    
    def index
        @students = Student.all
        session.delete(:current_course)
    end

    def show
        @student = Student.find(params[:id])
        @course = session[:current_course]
        if @course == nil
            @students = Student.all
        else
            @students = Student.all.where(:course => @student.course)
        end
        @next = nil
        @prev = nil
        @students.each_index do |i|
            if @students[i] == @student
                if i < @students.size
                   @next = @students[i+1]
                end
                if i > 0
                   @prev = @students[i-1] 
                end
            end
        end
        if @next == nil
           @next = @students[0]
        end
        if @prev == nil
           @prev = @students[-1]
        end
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
    
    def edit
       @student = Student.find params[:id] 
       @courses = Course.all
    end
    
    def update
       @student = Student.find params[:id]
       @courses = Course.all
       @student.update_attributes!(student_params)
       flash[:notice] = "#{@student.first_name} #{@student.last_name} was successfully updated."
       redirect_to student_path(@student)
    end
    
    private
    
    def student_params
        params.require(:student).permit(:first_name, :last_name, :description, :image, :course_id)
    end
end
