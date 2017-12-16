class TeachersController < ApplicationController
    
    before_action :confirm_logged_in, :except => [:new, :create, :create_from_google]
    before_action :is_teacher, :except => [:show, :new, :create, :create_from_google]
    
    
    def show
        @teacher = Teacher.find(params[:id])
        @courses = Course.where(:teacher => @teacher)
        if session[:user_type] == "Teacher"
            if session[:user_id] != @teacher.id
                flash[:notice] = "Access Denied"
                redirect_to courses_path
            end
            @page_title = "QuizMe - Your Profile"
            @button_class = "title-bar-button"
        elsif session[:user_type] == "Student"
            if @teacher != Student.find(session[:user_id]).course.teacher
                flash[:notice] = "Access Denied"
                redirect_to course_path(Student.find(session[:user_id]).course_id)
            end
            @page_title = "QuizMe - " + @teacher.username
            @button_class = "hidden"
        end
    end
    
    def create
        @teacher = Teacher.new(teacher_params)
        if @teacher.save
            flash[:notice] = "#{@teacher.first_name} was successfully created."
            redirect_to teachers_path
        else
            flash[:warning] = "Something went wrong."
            redirect_to '/teachers/new'
        end
    end
    
    def create_from_google
        @teacher = Teacher.from_omniauth(env["omniauth.auth"])
        session[:user_id] = @teacher.id
        redirect_to teachers_path
    end
    
    def destroy
        @teacher = Teacher.find params[:id]
        if session[:username] == @teacher.username
            session[:username] = nil
            session[:user_id] = nil
        end
        @teacher.destroy
        flash[:notice] = "#{@teacher.username} was successfully deleted"
        redirect_to "/"
    end
    
    def edit
       @teacher = Teacher.find params[:id] 
       @courses = Course.all
    end
    
    def update
        @teacher = Teacher.find params[:id]
       if @teacher.update_attributes(teacher_params)
           session[:username] = @teacher.username
           flash[:notice] = "#{@teacher.first_name} #{@teacher.last_name} was successfully updated."
       else
           flash[:warning] = "Teacher could not be updated because #{@teacher.errors.full_messages}"
       end
       redirect_to teacher_path(@teacher)
    end
    
    
    
    def new
       @teacher = Teacher.new
       #@teacher.image = File.new("#{Rails.root}/app/assets/images/default_profile.jpg")
    end
    
    def onSignIn(googleUser)
        profile = googleUser.getBasicProfile();
        puts('ID: ' + profile.getId()); # Do not send to your backend! Use an ID token instead.
        puts('Name: ' + profile.getName());
        puts('Image URL: ' + profile.getImageUrl());
        puts('Email: ' + profile.getEmail()); # This is null if the 'email' scope is not present.
    end
    
    private

    def index
        @teachers = Teacher.all
    end
    
    def teacher_params
        params.require(:teacher).permit(:username, :first_name, :last_name, :description, :image, :password_digest, 
                                    :password, :password_confirmation, :email_address)
    end
end
