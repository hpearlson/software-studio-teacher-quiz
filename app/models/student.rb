class Student < ActiveRecord::Base
    belongs_to :course
    has_secure_password
    has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png", 
        :storage => :cloudinary, :path => ':id/:style/:filename'
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    
    ALPHA = /\A[A-Za-z]+\Z/
    ALPHANUMERIC = /\A[a-zA-Z0-9]+\Z/i
    
    validates :first_name, :presence => true,
                            :length => { :within => 3..25 },
                            :format => ALPHA                        
    
    validates :last_name, :presence => true,
                            :length => { :within => 3..25 },
                            :format => ALPHA
    
    #validates_presence_of :course
    #validates_associated :course
    validates_presence_of :image
    
    def full_name
        "#{self.first_name} #{self.last_name}"
    end

end
