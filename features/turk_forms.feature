Feature: Turk Forms
  As a service pulling this form in
  In order create the form on AMT
  I want to be able to view

  Scenario: Turk Form show
    Given a turk_form exists with body: "Some text", execution_id: 1
    When I go to the show page for that turk_form
    Then I should see "Some text"
  