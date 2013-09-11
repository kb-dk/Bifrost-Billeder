# -*- encoding : utf-8 -*-

Before do
  OmniAuth.config.test_mode = true

  OmniAuth.config.add_mock(:cas, {
      :uid => 'http://xxxx.com/openid?id=118181138998978630963',
      :info => { :name => 'Test User' },
      :extra => {
          :user => 'Test User',
          :gn => 'Test',
          :sn => 'User',
          :alephPID => 'spec-admin-pid'
      }
  })

end

After do
  visit root_url
  click_link 'Slet alle billeder'
  OmniAuth.config.test_mode = false
end
