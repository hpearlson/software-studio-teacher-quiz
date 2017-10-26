class StudentsController < ApplicationController
    
    def index
        @students = Student.all
        flash[:page] = "from index"
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
        if flash[:page] != nil
            @start_page = 0
            @students.each_index do |i|
                @start_page += 1
                break if @student == @students[i]
            end
            @students = Kaminari.paginate_array(@students).page(@start_page).per(1)
        else
            @students = Kaminari.paginate_array(@students).page(params[:page]).per(1)
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
       @student = Student.find(params[:id])
       @courses = Course.all
       @student.update_attributes!(student_params)
       flash[:notice] = "#{@student.first_name} #{@student.last_name} was successfully updated."
       redirect_to student_path(@student)
    end
    
    
    def quiz
        @course = session[:current_course]
        if @course == nil
            @students = Student.all
        else
            @students = Student.all.where(:course => session[:current_course])
        end
        if flash[:page] == nil
            @students = Kaminari.paginate_array(@students).page(params[:page]).per(1)
        else
            @students = Kaminari.paginate_array(@students).page(flash[:page]).per(1)
        end
        if flash[:correct] == "Correct!"
           @class = "visible"
        else
            @class = "hidden"
        end
    end
    
    def check_answer
        @check = params[:student].to_s.split('=>')
        @check2 = @check[1].split('"')
        @name = @check2[1]
        @page = params[:page]
        flash[:page] = @page
        @student = Student.find(params[:student_id])
        if @student.first_name == @name
            flash[:correct] = "Correct!"
        else
            flash[:correct] = "Incorrect!"
        end
        redirect_to quiz_students_path
    end
    
    private
    
    def student_params
        params.require(:student).permit(:first_name, :last_name, :description, :image, :course_id)
    end
end
