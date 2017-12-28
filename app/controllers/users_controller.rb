class UsersController < ApplicationController
    
    
    def create
        @user = User.new(user_params)
        
    end
    
    def show
        @user = User.find(params[:id])
    end
    
    def new
        @user = User.new
    end
    
    def update
       @user = User.find(params[:id])
       if @user.update_attributes(user_params)
           flash[:notice] = "#{@user.first_name} #{@user.last_name} was successfully updated."
       else
           flash[:warning] = "#{@user.first_name} #{@user.last_name} could not be updated because #{@user.errors.full_messages}"
       end
       redirect_to user_path(@user)
    end
    
    def destroy
        @user = User.find params[:id]
        @user.destroy
        flash[:notice] = "#{@user.first_name} was successfully deleted"
        redirect_to users_path
    end
    
    private
    
    def index
        @users = User.all
    end
    
    def user_params
        params.require(:user).permit(:username, :first_name, :last_name, :description, :image, :password_digest, 
            :password, :password_confirmation, :email_address, :course_id, :generatedID)
    end
end
