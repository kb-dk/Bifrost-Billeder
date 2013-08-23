Rails.application.config.middleware.use OmniAuth::Builder do
  
  provider :cas,
    :login_url => HydraHead::Application.config.cas[:login_url],
    :service_validate_url => HydraHead::Application.config.cas[:service_validate_url],
    :host => HydraHead::Application.config.cas[:host],
    :ssl => HydraHead::Application.config.cas[:ssl]
end

if HydraHead::Application.config.stub_authentication
  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:cas, {
    :uid => "username",
    :info => { :name => "Test User" },  
    :extra => {
      :user => "username",
    }
  })
end

OmniAuth.config.logger = Rails.logger