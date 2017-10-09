class CoursesController < ApplicationController
    def index
        @course = Course.all 
    end
    
    def show
    end
end
