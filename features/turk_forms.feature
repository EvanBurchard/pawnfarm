Feature: Turk Forms
  As a service pulling this form in
  In order create the form on AMT
  I want to be able to view

  Scenario: Turk Form show
    Given a tweet_scheme exists with title: "scheme 1", description: "this is a scheme", user_id: 1, id: 1
    And an execution exists with pawn_id: 1, scheme: the tweet_scheme, id: 1
    And a turk_form exists with body: "Some text", execution: the execution
    When I go to the show page for that turk_form
    Then I should see "Some text"
  