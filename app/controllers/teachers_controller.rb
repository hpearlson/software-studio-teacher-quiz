class TeachersController < ApplicationController
    
    before_action :confirm_logged_in, :except => [:new, :create]
    
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
            flash[:warning] = "Something went wrong."
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
       @teacher = Teacher.find params[:id] 
       @courses = Course.all
    end
    
    def update
        @teacher = Teacher.find params[:id]
       if @teacher.update_attributes(teacher_params)
           flash[:notice] = "#{@teacher.first_name} #{@teacher.last_name} was successfully updated."
       else
           flash[:warning] = "Teacher could not be updated because #{@teacher.errors.full_messages}"
       end
       redirect_to teacher_path(@teacher)
    end
    
    def new
       @teacher = Teacher.new
    end
    
    def onSignIn(googleUser)
        profile = googleUser.getBasicProfile();
        puts('ID: ' + profile.getId()); # Do not send to your backend! Use an ID token instead.
        puts('Name: ' + profile.getName());
        puts('Image URL: ' + profile.getImageUrl());
        puts('Email: ' + profile.getEmail()); # This is null if the 'email' scope is not present.
    end
    
    private
    
    def teacher_params
        params.require(:teacher).permit(:username, :first_name, :last_name, :description, :image, :password_digest, :password, :email_address)
    end
end
