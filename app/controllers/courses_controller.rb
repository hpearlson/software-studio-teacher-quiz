class CoursesController < ApplicationController
    def index
        @course = Course.all 
    end
    
    def show
       "This will show a course information"
    end
end
