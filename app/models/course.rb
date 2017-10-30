class Course < ActiveRecord::Base
    has_many :students
    belongs_to :teacher
    
    validates_presence_of :teacher
    validates_presence_of :course_name
end
