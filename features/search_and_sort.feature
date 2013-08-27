# -*- encoding : utf-8 -*-
Feature: Search for image metadata
  As a user I want to search for images using metadata

Scenario: Successful search for image metadata
  Given I am at the home page for Bifrost-Billeder
  When I search for 'Carreby'
  Then I should get 31 search results

Scenario: Successful search for Titel metadata
  Given I am at the home page for Bifrost-Billeder
  And I have selected 'Titel' search
  When I search for 'ABC Hansen'
  Then I should get 1 search result

Scenario: Successful search for Forfatter metadata
  Given I am at the home page for Bifrost-Billeder
  And I have selected 'Forfatter' search
  When I search for 'Carreby'
  Then I should get 31 search results

Scenario: Successful search for Område metadata
  Given I am at the home page for Bifrost-Billeder
  And I have selected 'Område' search
  When I search for 'Amager'
  Then I should get 5 search results

Scenario: Successful sorting of results by Titel
  Given I am at the home page for Bifrost-Billeder
  When I search for 'Carreby'
  And I sort by title
  Then I should get 'ABC Hansen' as the first result
  And I should get 'Vald Larsen' as the last result
