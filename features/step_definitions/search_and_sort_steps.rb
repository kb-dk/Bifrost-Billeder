# -*- encoding : utf-8 -*-
require 'capybara/rspec'

Given(/^I am signed in with provider "([^"]*)"$/) do |arg|
  visit new_user_session_path
  page.should have_content 'Indlæs alle billeder'
end

When(/^test data is available$/) do
  click_link 'Indlæs alle billeder'
end

Given(/^I am at the home page for Bifrost\-Billeder$/) do
  visit root_url
end

When(/^I sort by title$/) do
  click_link 'Titel'
end

Then(/^I should get 'ABC Hansen' as the first result$/) do
  page.should have_content 'ABC Hansen'
  page.has_xpath?('//*[@id="documents"]/div[1]/div/div[2]/div/h2/a').should == true

end

When(/^I should get 'Vald Larsen' as the last result$/) do
  click_link '4'
  page.should have_content 'Vald Larsen'
  page.has_xpath?('//*[@id="documents"]/div/div/div[2]/dl/dd[1]').should == true
end

Then(/^I should get (\d+) search results$/) do |arg|
  page.should have_content 'of ' + arg.to_s
end

When(/^I have selected (.*) search$/) do |metadata_field_name|
  select metadata_field_name, :from => 'search_field'
end

When(/^I search for (.*)$/) do |search_term|
  fill_in 'q', :with => search_term
  click_button 'search'
end