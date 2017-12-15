class Course < ActiveRecord::Base
    has_many :students
    belongs_to :teacher
    
    
    SENTENCES = /\A[a-zA-Z0-9.,?!\s]+\Z/i
    
    
    validates_presence_of :course_name
    validates_presence_of :teacher_id
    
    validates :course_name, :presence => true,
                            :length => { :within => 3..100 },
                            :format => SENTENCES 

    paginates_per 20
end
