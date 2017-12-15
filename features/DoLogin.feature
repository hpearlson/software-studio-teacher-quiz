Feature: Login
  
Scenario: Login as Teacher
  Given a valid teacher
  When I go to the home page
  When I follow "Login"
  Then I should see "Login here"
  When I fill in "Username" with "msummer"
  And I fill in "Password" with "password"
  And I press "Log In"
  Then I should see "Your courses"