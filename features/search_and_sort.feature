# -*- encoding : utf-8 -*-
Feature: Search for image metadata
  As a user I want to search for images using metadata

  Background: Logged in
    Given I am signed in with provider "cas"
    And test data is available

  Scenario: Successful search for image metadata
    Given I am at the home page for Bifrost-Billeder
    When I search for "Carreby"
    Then I should get 31 search results

  Scenario Outline: search by metadata field
    Given I am at the home page for Bifrost-Billeder
    And I have selected <metadata_field_name> search
    When I search for <search_term>
    Then I should get <number> search results
  Examples:
    | metadata_field_name | search_term | number |
    | Alt                 | Carreby     |31      |
    | Titel               | ABC Hansen  |1       |
    | Forfatter           | Carreby     |31      |
    | Område              | Amager      |5       |

  Scenario: Successful sorting of results by Titel
    Given I am at the home page for Bifrost-Billeder
    When I search for "Carreby"
    And I sort by title
    Then I should get 'ABC Hansen' as the first result
    And I should get 'Vald Larsen' as the last result
