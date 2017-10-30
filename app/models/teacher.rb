class Teacher < ActiveRecord::Base
    has_many :courses
    has_secure_password
    has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png", 
        :storage => :cloudinary, :path => ':id/:style/:filename'
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    
    EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
    
    validates :username, :presence => true,
                        :uniqueness => true
                        
    validates :password, :presence => true,
                        :confirmation => true
    validates_presence_of :first_name
    validates_presence_of :last_name
    
    validates :email_address, :presence => true,
                            :format => EMAIL_REGEX
end
