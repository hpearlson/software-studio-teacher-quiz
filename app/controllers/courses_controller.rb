class CoursesController < ApplicationController
    def index
        @courses = Course.all 
    end
    
   # def show
       # @courses = 
    #end
end
