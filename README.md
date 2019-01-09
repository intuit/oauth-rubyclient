# oauth-rubyclient

Intuit OAuth Ruby Client
==========================

This tutorial describes how to use Intuit Ruby OAuth Client Library to generate access tokens for your QuickBooks Online Companies data. The Ruby OAuth Client Library  provides a set of methods that make it easier to work with Intuit’s OAuth and OpenID protocol:

  - Generating Authorization URL
  - Getting OAuth2 Bearer Token
  - Getting User Info
  - Validating OpenID token
  - Refreshing OAuth2 Token
  - Revoking OAuth2 Token
  - Migrating tokens from OAuth1.0 to OAuth2
 
 If you are not familiar with Intuit OAuth protocol, please refer to [Authentication and authorization page](https://developer.intuit.com/app/developer/qbo/docs/develop/authentication-and-authorization/oauth-2.0) for general information on OAuth.
 
The Ruby OAuth client would require Ruby version >= 1.9.0, and RubyGem version >= 1.3.5


## Installation

The Ruby OAuth library use gem for installation. To install the library, run:

    $ gem install 'intuit-oauth'
    
You can also download the source code and run:

    $ gem build intuit-oauth.gemspec

to build your own gem if you want to modify a certain functions in the library
    
## Usage Examples

The below example tells how to construct the IntuitOAuth Client and use it to generate an OAuth 2 token.

```ruby
require 'intuit-oauth'

client = IntuitOAuth::Client.new('client_id', 'client_secret', 'redirectUrl', 'environment')
scopes = [
    IntuitOAuth::Scopes::ACCOUNTING
]

authorizationCodeUrl = oauth_client.code.get_auth_uri(scopes)
# => https://appcenter.intuit.com/connect/oauth2?client_id=clientId&redirect_uri=redirectUrl&response_type=code&scope=com.intuit.quickbooks.accounting&state=rMwcoDITc2N6FJsUGGO9

oauth2Token = oauth_client.token.get_bearer_token('the authorization code returned from authorizationCodeUrl')
# => #<IntuitOAuth::ClientResponse:0x00007f9152b5c418 @access_token="the access token", @expires_in=3600, @refresh_token="the refresh token", @x_refresh_token_expires_in=8726400>

```

### Initialize OAuth client object

Create an OAuth 2 client to send requests

    oauth_client = IntuitOAuth::Client.new('YourClientID', 'YourClientSecret', 'http://localhost:3000/token/new', 'sandbox')

### Add scopes

Define the scopes for the app

    scopes = [
        IntuitOAuth::Scopes::ACCOUNTING
    ]
    
### General Authorization Code URL

The URL for users to click on the "Authorizate" button. An authorization code will sent to the redirect URL defined in your app

    url = oauth_client.code.get_auth_uri(scopes)
    
### Exchange Authorization Code for OAuth 2.0 Token

Once the user has authorized your app, an authorization code will be sent to your Redirect_URL defined in your client. Exchange the authorization code for an OAuth 2.0 token object.

    result = oauth_client.token.get_bearer_token('The_authorization_code')
    
    
### Refresh Token

Refresh the OAuth 2.0 token using refresh token. Remember to store the OAuth 2.0 refresh token to your own database.

    newToken = oauth_client.token.refresh_tokens('Your_refresh_token')
    
### Get User Info

Get the user info based on the scopes for OpenID

    result=oauth_client.openid.get_user_info('accessToken')

### Call migration method

If you have migrated your OAuth 1.0 app to OAuth 2.0 app, and want to exchange your OAuth 1.0 token to OAuth 2.0 token, use migrate_tokens method

    result=oauth_client.Migrate.migrate_tokens(consumer_key, consumer_secret, access_token, access_secret, scopes)
    
Issues and Contributions
------------------------

Please open an `issue <https://github.com/intuit/oauth-rubyclient/issues>` on GitHub if you have a problem, suggestion, or other comment.

Pull requests are welcome and encouraged! Any contributions should include new or updated unit tests as necessary to maintain thorough test coverage.

License
-------

intuit-oauth is provided under Apache 2.0 found `<https://github.intuit.com/hlu2/oauth-rubyclient/blob/master/LICENSE>`__
