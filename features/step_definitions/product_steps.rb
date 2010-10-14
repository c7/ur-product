# encoding: utf-8
# Cucumber
require 'spec/expectations'
require 'cucumber/formatter/unicode'
$:.unshift(File.dirname(__FILE__) + '/../../lib')

# UR Product
require 'ur-product'

Before do
 @product   = nil
 @products  = nil
 @result    = nil
end

# Given
Given /^I want the product (\d+)$/ do |id|
  @id = id
end

Given /^I want the products (.+)$/ do |ids|
  @ids = ids.split(' and ')
end

# When

When /^I get the product$/ do
  @product = UR::Product.find(@id)
end

When /^I get the products$/ do
  @products = UR::Product.find(@ids)
end

When /^I get the product it should throw "([^\"]*)"$/ do |exception|
  lambda { UR::Product.find(@id) }.should raise_error(exception)
end

# Then

Then /^the title should be "(.*)"/ do |title|
  @product.title.should == title 
end

Then /^it should have (.*)/ do |boolean_method|
  @product.send("has_#{boolean_method}?").should == true
end

Then /^one (.*) in (.*) should be "(.*)"$/ do |field, method, value|
  values = []
  
  @product.send(method).each do |product| 
    values << product.send(field)
  end
  
  values.include?(value).should be(true)
end

Then /^the result should contain (\d+) products$/ do |expected_size|
  @products.size.should == expected_size.to_i
end

Then /^the (.+) product should have the title "([^\"]*)"$/ do |index, title|
  count_translations = { 'first' => 0, 'second' => 1 }
  
  @products[count_translations["#{index}"]].title.should == title
end
