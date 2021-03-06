class Teacher < ActiveRecord::Base
    has_many :courses
    has_secure_password
    has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png", 
        :storage => :cloudinary, :path => ':id/:style/:filename'
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    
    EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i
    ALPHA = /\A[A-Za-z]+\Z/
    ALPHANUMERIC = /\A[a-zA-Z0-9]+\Z/i
    
    validates :username, :presence => true,
                        :uniqueness => true,
                        :length => { :within => 3..25 },
                        :format => ALPHANUMERIC
                        
                        
    validates :password, :presence => true,
                        :confirmation => true,
                        :length => { :within => 3..25 },
                        :format => ALPHANUMERIC
    
    validates :first_name, :presence => true,
                            :length => { :within => 3..25 },
                            :format => ALPHA                        
    
    validates :last_name, :presence => true,
                            :length => { :within => 3..25 },
                            :format => ALPHA
    
    validates :email_address, :presence => true,
                            :format => EMAIL_REGEX
                            
                            
    def full_name
        "#{self.first_name} #{self.last_name}"
    end
    
    def self.from_omniauth(auth)
        @foundTeacher = Teacher.where(:email_address => auth.info.email).first
        
        if !@foundTeacher.nil?
            return @foundTeacher
        end
        
        where(email_address: auth.info.email).first_or_initialize.tap do |user|
            user.id = Time.now.to_i.to_s
            user.first_name = auth.info.name
            user.email_address = auth.info.email
            user.first_name = auth.info.first_name
            user.last_name = auth.info.last_name
            user.password = "jffjd" + Time.now.to_i.to_s
            user.username = auth.info.first_name + Time.now.to_i.to_s
            user.save!
        end
    end
                            
    
end
