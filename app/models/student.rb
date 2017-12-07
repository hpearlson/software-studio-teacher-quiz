class Student < ActiveRecord::Base
    belongs_to :course
    has_secure_password :validations => false
    has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png", 
        :storage => :cloudinary, :path => ':id/:style/:filename'
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    
    ALPHA = /\A[A-Za-z]+\Z/
    ALPHANUMERIC = /\A[a-zA-Z0-9]+\Z/i
    SENTENCES = /\A[a-zA-Z0-9.,?!\s]+\Z/i
    EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
    
    validates :first_name, :presence => true,
                            :length => { :within => 3..25 },
                            :format => ALPHA                        
    
    validates :last_name, :presence => true,
                            :length => { :within => 3..25 },
                            :format => ALPHA
    
    validates :username, :length => { :maximum => 25 },
                            :format => { :with => ALPHANUMERIC, :allow_nil => true },
                            :uniqueness => { :allow_nil => true } 
    
    validates :password, :length => { :maximum => 25 },
                            :format => { :with => ALPHANUMERIC, :allow_nil => true },
                            :confirmation => true
    
    validates :description, :length => { :maximum => 225 },
                                :format => { :with => SENTENCES, :allow_nil => true, :allow_blank => true }
    
    validates :email_address, :format => { :with => EMAIL_REGEX, :allow_nil => true }
    
    
    validates_presence_of :image
    
    def full_name
        "#{self.first_name} #{self.last_name}"
    end
    
    def self.apply_spaced_repetition(usr_id)
        @teacher = Teacher.find(usr_id)
        @all_courses = Course.where(:teacher => @teacher)
        @students = Student.where(course: @all_courses)
        
        @students.each do |student|
            if student.quiz_score_day_updated.nil?
                student.quiz_score_day_updated = Time.now.beginning_of_day.to_i
            end
            
            if student.quiz_score == nil
               student.update_attribute(:quiz_score, 0) 
            elsif student.quiz_score > 1
                if Time.now.to_i - ((student.quiz_score - 1)**2)*84000 >= student.quiz_score_day_updated
                    student.update_attribute(:quiz_score, student.quiz_score - 1)
                end
            elsif student.quiz_score == 1
                if Time.now.to_i - 84000 >= student.quiz_score_day_updated
                    student.update_attribute(:quiz_score, student.quiz_score - 1)
                end
            end
        end
    end
    
    paginates_per 20
end
