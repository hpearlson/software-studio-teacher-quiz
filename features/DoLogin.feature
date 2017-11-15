Feature: Add a New Course
  
Scenario: Add a course
  Given I am on the home page
  When I follow "Login"
  Then I should be on the Login page
  When I fill in "Username" with "Aristotle"
  And I fill in "Password" with "Politics"
  And I press "Log In"
  Then I should be on the Courses home page
  And I should see "Add New Course"