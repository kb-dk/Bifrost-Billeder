Rails.application.config.middleware.use OmniAuth::Builder do
  
  provider :cas,
    :login_url => SIFDBilleder::Application.config.cas[:login_url],
    :service_validate_url => SIFDBilleder::Application.config.cas[:service_validate_url],
    :host => SIFDBilleder::Application.config.cas[:host],
    :ssl => SIFDBilleder::Application.config.cas[:ssl]
end

if SIFDBilleder::Application.config.stub_authentication
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:cas, {
    :uid => "username",
    :pid => "123456",
    :info => { :name => "Test User" },  
    :extra => {
      :user => "username",
    }
  })
end

OmniAuth.config.logger = Rails.logger