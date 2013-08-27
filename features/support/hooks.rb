# -*- encoding : utf-8 -*-
Before do
  visit root_url
  click_link 'Indlæs alle billeder'
end

After do
  visit root_url
  click_link 'Slet alle billeder'
end