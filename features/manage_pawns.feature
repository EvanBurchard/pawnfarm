Feature: Pawn Management
  In order to properly be able to direct my pawns
  As a chess master
  I want to be able to create, view, edit, and delete my pawns
  
  Scenario: Pawn creation
    Given a user exists with login: "myself", password: "secret", email: "myself@flksd.com"
    And I am logged in as "myself" with password "secret"
    And I am on the new page for pawns
		And I fill in the following:
  		 | Name       | new_pawn    |
  		 | Description | mwahahahahaha |
  		 | Twitter username | twitter_username    |
  		 | Twitter password       | secret    |
		And I press "Create"
		Then a pawn should exist with name: "new_pawn"
    And show me the page
    
  Scenario: Pawn index
    Given a pawn exists with name: "pawn 1", description: "this is a pawn", twitter_username: "username", twitter_password: "secret", user_id: 1
    And I am on the pawn index page
    Then I should see "Pawns" within "h2"
    Then I should see "pawn 1" 
    Then I should see "this is a pawn" 

  Scenario: Pawn show
    Given a pawn exists with name: "pawn 1", description: "this is a pawn", twitter_username: "username", twitter_password: "secret", user_id: 1
    When I go to the show page for that pawn
    Then I should see "pawn 1" within "h1"
    Then I should see "this is a pawn" within "p"
     
  Scenario: Pawn editing
    Given a pawn exists with name: "pawn 1", description: "this is a pawn", twitter_username: "username", twitter_password: "secret", user_id: 1
    And a user exists with login: "myself", password: "secret", email: "myself@flksd.com", id: 1
    And I am logged in as "myself" with password "secret"
    When I go to the edit page for that pawn
    And I fill in the following:
     | Name       | edited_pawn |
     | Description | mwahahahahaha |
    And I press "Update"
    Then I should be on the show page for that pawn
    And I should see "edited_pawn" within "h1"
    And I should see "mwahahahahaha" within "p"

  Scenario: Pawn deletion
    Given a pawn exists with name: "pawn 1", description: "this is a pawn", twitter_username: "username", twitter_password: "secret", user_id: 1
    And a user exists with login: "myself", password: "secret", email: "myself@flksd.com", id: 1
    And I am logged in as "myself" with password "secret"
    When I go to the show page for that pawn
    And I follow "Delete"
    Then I should be on the pawn index page
    And that pawn should not exist
  
  Scenario: Creating pawn with schemes attached
    Given a user exists with login: "myself", password: "secret", email: "myself@flksd.com", id: 1
    And a tweet_scheme exists with title: "scheme 1", description: "this is a scheme", user_id: 1
    And I am logged in as "myself" with password "secret"
    And I am on the new page for pawns
		And I fill in the following:
  		 | Name       | new_pawn    |
  		 | Description | mwahahahahaha |
  		 | Twitter username | twitter_username    |
  		 | Twitter password       | secret    |
  	And I check "pawn_scheme_ids_"	 
		And I press "Create"
		Then a pawn should exist with name: "new_pawn"
