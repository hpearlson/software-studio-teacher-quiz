Feature: Add a New Course
  
Scenario: Add a course
  Given session[:user_id] = 1
  Given I am on the Courses home page
  When I follow "Add New Course"
  Then I should be on the Create New Course page
  When I fill in "Course Name" with "Test Course"
  And I press "Save Changes"
  Then I should be on the Courses home page
  And I should see "Test Course"