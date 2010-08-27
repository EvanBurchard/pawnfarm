Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |login, password|
  unless login.blank?
    visit login_url
    fill_in "Login", :with => login
    fill_in "Password", :with => password
    click_button "Login"
  end
end
