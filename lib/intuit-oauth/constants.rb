module IntuitOAuth
  class Config
    DISCOVERY_URL_SANDBOX = 'https://developer-stage.intuit.com/.well-known/openid_configuration/'
    DISCOVERY_URL_PROD = 'https://developer.intuit.com/.well-known/openid_configuration/'
    MIGRATION_URL_SANDBOX = 'https://developer-sandbox.api.intuit.com/v2/oauth2/tokens/migrate'
    MIGRATION_URL_PROD = 'https://developer.api.intuit.com/v2/oauth2/tokens/migrate' 
  end

  class Scopes
    ACCOUNTING = 'com.intuit.quickbooks.accounting'
    PAYMENTS = 'com.intuit.quickbooks.payment'
    OPENID = 'openid'
    PROFILE = 'profile'
    EMAIL = 'email'
    PHONE = 'phone'
    ADDRESS = 'address'

    # whitelisted BETA apps only
    PAYROLL = 'com.intuit.quickbooks.payroll'
    PAYROLL_TIMETRACKING = 'com.intuit.quickbooks.payroll.timetracking'
    PAYROLL_BENEFITS = 'com.intuit.quickbooks.payroll.benefits'
  end

  class Version
    VERSION = '0.0.1'
    USER_AGENT = "Intuit-OAuthClient-Ruby#{VERSION}-#{RUBY_PLATFORM}"
  end
end
