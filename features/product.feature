# language: en
Feature: UR Product
  As a product
  I want to be able to retrieve my data from the Metadata Cache

  Scenario: Product with siblings
    Given I want the product 100001
    When I get the product
    Then the title should be "Antarktis : En hotad kontinent"
    And it should have relations
    And it should have siblings
    And one title in siblings should be "Antarktis : Ett vittne om framtiden"

  Scenario: Invalid ID
    Given I want the product 99991
    When I get the product it should throw "UR::InvalidProductID"

  Scenario: Multiple products
    Given I want the products 100001 and 150423
    When I get the products
    Then the result should contain 2 products
    And the second product should have the title "Vetenskapslandet : Säsong 6 prg. 13"

  Scenario: Check if a product has an image
    Given I want the product 100001
    When I get the product
    Then it should have image
