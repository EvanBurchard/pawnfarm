Feature: Scheme Management
  In order manage the directions for my schemes
  As a chessmaster
  I want to be able to create, view, edit, and delete schemes of my schemes

  Scenario: Scheme creation
    Given a user exists with login: "myself", password: "secret", email: "myself@flksd.com"
    And I am logged in as "myself" with password "secret"
    And I am on the new page for schemes
		And I fill in the following:
  		 | Title       | new_scheme    |
  		 | Description | mwahahahahaha |
  	And I select "Tweet" from "scheme_type"	 
		And I press "Create"
		Then a scheme should exist with title: "new_scheme"
    
  Scenario: Scheme index
    Given a tweet_scheme exists with title: "scheme 1", description: "this is a scheme", user_id: 1
    And I am on the scheme index page
    Then I should see "Schemes" within "h2"
    Then I should see "scheme 1" 
    Then I should see "this is a scheme" 

  Scenario: Scheme show
    Given a tweet_scheme exists with title: "scheme 1", description: "this is a scheme", user_id: 1
    When I go to the show page for that tweet_scheme
    Then I should see "scheme 1" within "h1"
    Then I should see "this is a scheme" within "p"
     
  Scenario: Scheme editing
    Given a tweet_scheme exists with title: "scheme 1", description: "this is a scheme", user_id: 1
    And a user exists with login: "myself", password: "secret", email: "myself@flksd.com", id: 1
    And I am logged in as "myself" with password "secret"
    When I go to the edit page for that tweet_scheme
    And I fill in the following:
     | Title       | edited_scheme |
     | Description | mwahahahahaha |
    And I press "Update"
    Then I should be on the show page for that tweet_scheme
    And I should see "edited_scheme" within "h1"
    And I should see "mwahahahahaha" within "p"

  Scenario: Scheme deletion
    Given a tweet_scheme exists with title: "scheme 1", description: "this is a scheme", user_id: 1
    And a user exists with login: "myself", password: "secret", email: "myself@flksd.com", id: 1
    And I am logged in as "myself" with password "secret"
    When I go to the show page for that tweet_scheme
    And I follow "Delete"
    Then I should be on the scheme index page
    And that tweet_scheme should not exist
  
