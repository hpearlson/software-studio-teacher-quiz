Feature: Add a New Course
  
Scenario: Add a course
  Given a valid teacher
  And a logged in teacher
  When I go to the Courses home page
  And I follow "Add New Course"
  Then I should see "Add course"
  When I fill in "Course Name" with "Test Course"
  And I press "Save Changes"
  Then I should see "Test Course"