class CoursesController < ApplicationController
    def index
        @courses = Courses.all 
    end
    
    def show
    end
end
