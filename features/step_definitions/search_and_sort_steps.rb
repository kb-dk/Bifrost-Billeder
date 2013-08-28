# -*- encoding : utf-8 -*-
require 'capybara/rspec'

Given(/^I am at the home page for Bifrost\-Billeder$/) do
  visit root_url
end

When(/^I search for 'Carreby'$/) do
  fill_in 'q', :with => 'Carrebye'
  click_button 'search'
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

When(/^I have selected 'Titel' search$/) do
  select 'Titel', :from => 'search_field'
end

When(/^I search for 'ABC Hansen'$/) do
  fill_in 'q', :with => 'ABC Hansen'
  click_button 'search'
end

When(/^I have selected 'Forfatter' search$/) do
  select 'Forfatter', :from => 'search_field'
end

When(/^I have selected 'Område' search$/) do
  select 'Område', :from => 'search_field'
end

When(/^I search for 'Amager'$/) do
  fill_in 'q', :with => 'Amager'
  click_button 'search'
end

Then(/^I should get (\d+) search result$/) do |arg|
  page.should have_content 'of ' + arg.to_s
end

Then(/^I should get (\d+) search results$/) do |arg|
  page.should have_content 'of ' + arg.to_s
end