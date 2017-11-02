class StudentsController < ApplicationController  
    
    before_action :confirm_logged_in

    def index
        @teacher = Teacher.find(session[:user_id])
        @courses = Course.where(:teacher => @teacher)
        @students = Student.all.where(course: @courses)
        session.delete(:current_course)
    end

    def show
        @student = Student.find(params[:id])
        if Teacher.find(session[:user_id]) != @student.course.teacher
  	        flash[:notice] = "Access Denied"
  	        redirect_to courses_path
  	    end
        @course = session[:current_course]
        if @course == nil
            @students = Student.where(course: Course.where(:teacher => Teacher.find(session[:user_id])))
        else
            @students = Student.where(:course => @student.course)
        end
        @next = nil
        @prev = nil
        @next_class = "visible"
        @prev_class = "visible"
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
            @next_class = "hidden"
        end
        if @prev == nil
            @prev_class = "hidden"
        end
    end

    def create
        @student = Student.new(student_params)
        if @student.save
            flash[:notice] = "#{@student.first_name} was successfully created."
        else
            flash[:notice] = "Student could not be created because #{@student.errors.full_messages}"
        end
        redirect_to students_path
    end

    def new
       @student = Student.new
       @teacher = Teacher.find(session[:user_id])
       @courses = Course.where(:teacher => @teacher)
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
       if @student.update_attributes(student_params)
           flash[:notice] = "#{@student.first_name} #{@student.last_name} was successfully updated."
       else
           flash[:warning] = "#{@student.first_name} #{@student.last_name} could not be updated because #{@student.errors.full_messages}"
       end
       redirect_to student_path(@student)
    end
    
    
    def quiz
        @course = session[:current_course]
        if @course == nil
            @teacher = Teacher.find(session[:user_id])
            @all_courses = Course.where(:teacher => @teacher)
            @students = Student.where(course: @all_courses)
        else
            @students = Student.where(:course => session[:current_course])
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
        if @student.full_name == @name
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
    
    def confirm_logged_in
        unless session[:user_id]
          flash[:notice] = "Please log in."
          redirect_to(access_login_path)
        end
    end
end
