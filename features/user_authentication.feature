Feature: User Authentication
	In order to access my personal information on the site
	As a user
	I want to login, logout, and register
	
	Scenario: User Registration
		Given I am on the registration page
		And I fill in the following:
			|  Email						|  john@doe.com		|
			|  Login						|  johndoe			|
			|  Password						|  secret			|
			|  Password confirmation		|  secret			|
		And I press "Register"
		Then I should be on the home page 
		And a user should exist with email: "john@doe.com"
		
	Scenario: User Login
		Given a user exists with login: "jane"
		When I go to the login page
		And I fill in the following:
			|  Login						|  jane			|
			|  Password						|  secret			|
		And I press "Login"
		Then I should be on the home page
				
	Scenario: User Login with email
		Given a user exists with email: "jane@doe.com"
		When I go to the login page
		And I fill in the following:
			|  Login						|  jane@doe.com		|
			|  Password						|  secret			|
		And I press "Login"  		
		Then I should be on the home page
    
	Scenario: Failed user login
		Given I go to the login page
		When I fill in the following:
			|  Login						|  jane@doe.com		|
			|  Password						|  wrong_password			|
		And I press "Login"  		
		Then I should be on the login page