class AccessController < ApplicationController

  before_action :confirm_logged_in, :except => [:home, :login, :attempt_login, :logout, :accountType]
  
  def menu
    # display text & links
  end
  
  def home
    # display text & links
  end

  def login
    # login form
  end
  
  def accountType
    # display text & links
  end
  
  def attempt_login
    if params[:username].present? && params[:password].present?
      if Student.where(:username => params[:username]).first == nil
        found_user = Teacher.where(:username => params[:username]).first
      else
        found_user = Student.where(:username => params[:username]).first
      end
      if found_user
        authorized_user = found_user.authenticate(params[:password])
        
      end
    end
  
    if authorized_user
      session[:user_id] = authorized_user.id
      session[:username] = authorized_user.username
      session[:user_type] = authorized_user.class.to_s
      flash[:notice] = "You are now logged in, " + authorized_user.username
      if session[:user_type] == "Teacher"
        redirect_to courses_path
      elsif session[:user_type] == "Student"
        redirect_to student_path(Student.find(session[:user_id]))
      else
        flash[:notice] = "Something went wrong"
        redirect_to "/"
      end
    else
      flash.now[:notice] = "Invalid username/password combination."
      render('login')
    end
  
  end
  
  def logout
    session[:user_id] = nil
    session[:username] = nil
    session[:user_type] = nil
    flash[:notice] = 'Logged out'
    redirect_to('/home')
  end
  
  
end
