teachers = [
    [ "Myranda", "Summers", "test test test test test", "msummer"],
    [ "Autumn", "Summers", "testtesttestttesttest", "autumn"]
    ]
    
courses = [
    ["Introduction to Computer Science", "msummer"],
    ["Software Studio", "msummer"],
    ["Artificial Intelligence", "autumn"]
    ]

students = [
    ["Yongguk", "Bang", "Chyeah", "yongguk.jpg", "Software Studio"],
    ["Himchan", "Kim", "Literally the Best. Absolutely Perfect.", "himchan.jpg", "Software Studio"],
    ["Daehyun", "Jung", "Only here for Youngjae", "bapdaehyun.jpg", "Software Studio"],
    ["Youngjae", "Yoo", "Literal genius", "youngjae.jpg", "Software Studio"],
    ["Jongup", "Moon", "...", "jongup.jpg", "Software Studio"],
    ["Hongbin", "Lee", "", "hongbin.jpg", "Artificial Intelligence"]
    ]

students_with_login = [
    ["Junhong", "Choi", "Way too tall. Like seriously.", "zelo.jpg", "Software Studio", "zelo"],
    ["Hakyeon", "Cha", "Slave to the database", "N.jpg", "Artificial Intelligence", "nnnnn"],
    ["Taekwoon", "Jung", "", "leo.jpg", "Artificial Intelligence", "leo"],
    ["Jaehwan", "Lee", "", "ken.jpg", "Artificial Intelligence", "ken"],
    ["Wonshik", "Kim", "", "ravi.jpg", "Artificial Intelligence", "ravi"],
    ["Sanghyuk", "Han", "", "hyuk.jpg", "Artificial Intelligence", "hyuk"],
    ["Jinwoo", "Park", "", "jinjin.jpg", "Introduction to Computer Science", "jinjin"],
    ["Myungjun", "Kim", "", "mj.jpg", "Introduction to Computer Science", "mj"],
    ["Dongmin", "Lee", "", "eunwoo.jpg", "Introduction to Computer Science", "eunwoo"]
    ]

teachers.each do |first_name, last_name, description, username|
    Teacher.create!(:first_name => first_name, :last_name => last_name, :description => description, 
    :username => username, :password => "password", :email_address => "test@test.edu", 
    :image => File.new("#{Rails.root}/app/assets/images/testProfilePics/Sgirl.jpg"))
end

courses.each do |name, teacher|
    Course.create!(:course_name => name, :teacher => Teacher.find_by(:username => teacher))
end

students.each do |first, last, desc, img, course|
    Student.create!(:first_name => first, :last_name => last, :description => desc, :course => Course.find_by(:course_name => course),
    :image => File.new("#{Rails.root}/app/assets/images/testProfilePics/#{img}"))
end

students_with_login.each do |first, last, desc, img, course, username|
    Student.create(:first_name => first, :last_name => last, :description => desc, :course => Course.find_by(:course_name => course), :image => File.new("#{Rails.root}/app/assets/images/testProfilePics/#{img}"), :username => username, :password => "password", :email_address => "test@test.edu")
end