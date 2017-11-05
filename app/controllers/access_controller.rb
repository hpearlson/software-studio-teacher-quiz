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
      found_user = Teacher.where(:username => params[:username]).first || Student.where(:username => params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
        
      end
    end
  
    if authorized_user
      session[:user_id] = authorized_user.id
      session[:username] = authorized_user.username
      flash[:notice] = "You are now logged in, " + authorized_user.username
      redirect_to("/courses")
    else
      flash.now[:notice] = "Invalid username/password combination."
      render('login')
    end
  
  end
  
  def logout
    session[:user_id] = nil
    session[:username] = nil
    flash[:notice] = 'Logged out'
    redirect_to('/home')
  end
  
  
end
