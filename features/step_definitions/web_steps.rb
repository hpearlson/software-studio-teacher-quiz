Given(/^a logged in teacher$/) do
  visit access_login_path
  fill_in "Username", :with => "msummer"
  fill_in "Password", :with => "password"
  click_button "Log In"
end

Given(/^a valid teacher$/)do
  @user = Teacher.create!(:username => "msummer", 
                          :password => "password",
                          :first_name => "Autumn",
                          :last_name => "Summers",
                          :email_address => "test@test.edu")
end

When(/^I go to the home page$/) do
  visit root_path
end

When(/^I go to the Courses home page$/) do
  visit courses_path
end

When ("I follow {string}") do |string|
  click_link(string)
end

When("I fill in {string} with {string}") do |field, text|
  fill_in(field, :with => text)
end

When("I press {string}") do |button|
  click_button(button)
end

Then("I should see {string}") do |string|
  assert page.has_content?(string)
end

