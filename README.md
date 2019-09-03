[![SDK Banner](views/SDK.png)](https://help.developer.intuit.com/s/SDKFeedback?cid=1130)

# oauth-rubyclient

[![Gem Version](https://badge.fury.io/rb/intuit-oauth.svg)](https://badge.fury.io/rb/intuit-oauth)

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


### Installation

The Ruby OAuth library use gem for installation. To install the library, run:

    $ gem install 'intuit-oauth'
    
You can also download the source code and run:

    $ gem build intuit-oauth.gemspec

to build your own gem if you want to modify a certain functions in the library
    
### Create client instance

In order to start using the library, the first step is to create a client object. Instantiate the IntuitOAuth object with app’s ClientID, ClientSecret, Redirect URL and the right environment. Valid values for environment include sandbox and production. redirect_uri should be set in your Intuit Developer app’s Keys tab under the right environment. 

  ```ruby
  require 'intuit-oauth'
  
  oauth_client = IntuitOAuth::Client.new('client_id', 'client_secret', 'redirectUrl', 'environment')
  ```

### General Authorization Code URL

After the client is created, use the client object to generate authorization URL by specifying scopes. It is shown below in code:

 ```ruby
  scopes = [
    IntuitOAuth::Scopes::ACCOUNTING
  ]
  
  authorizationCodeUrl = oauth_client.code.get_auth_uri(scopes)
  # => https://appcenter.intuit.com/connect/oauth2?   client_id=clientId&redirect_uri=redirectUrl&response_type=code&scope=com.intuit.quickbooks.accounting&state=rMwcoDITc2N6FJsUGGO9
  ```
Redirect your users to the authorizationCodeUrl, and an authorization code will be sent to the Redirect URL defined. The authorization code will be used to exchange for an oAuth 2.0 access token later. 

### Exchange Authorization Code for OAuth 2.0 Token

Once the user has authorized your app, an authorization code will be sent to your RedirectURL defined in your client. Exchange the authorization code for an OAuth 2.0 token object.

    result = oauth_client.token.get_bearer_token('The_authorization_code')
    
### Refresh Token

Your app must keep track of when a stored access token can be used and when the token must be refreshed. Use the refresh method to refresh the token when the token expired. ALWAYS STORE THE LATEST REFRESH TOKEN RETURNED. Below is an exanmple how to use the refresh method to refresh token:

    newToken = oauth_client.token.refresh_tokens('Your_refresh_token')
    
### Revoke Token

If your app is disconnected by the user, you would need to revoke the token. Use revoke_tokens method to revoke the token:

    trueOrFalse = oauth_client.token.revoke_tokens('the_token_you_want_to_revoke')


### Get User Info

If OpenID scope is set when you generate the authorization URL, you can use get_user_info to get the user information:

    result=oauth_client.openid.get_user_info('accessToken')
    


### Call migration method

If you have migrated your OAuth 1.0 app to OAuth 2.0 app, and want to exchange your OAuth 1.0 token to OAuth 2.0 token, use migrate_tokens method

    result=oauth_client.migration.migrate_tokens(consumer_key, consumer_secret, access_token, access_secret, scopes)

### A Complete Usage Example for Creating OAuth 2.0 token

The below example tells how to construct the IntuitOAuth Client and use it to generate an OAuth 2 token.

```ruby
require 'intuit-oauth'

oauth_client = IntuitOAuth::Client.new('client_id', 'client_secret', 'redirectUrl', 'environment')
scopes = [
    IntuitOAuth::Scopes::ACCOUNTING
]

authorizationCodeUrl = oauth_client.code.get_auth_uri(scopes)
# => https://appcenter.intuit.com/connect/oauth2?client_id=clientId&redirect_uri=redirectUrl&response_type=code&scope=com.intuit.quickbooks.accounting&state=rMwcoDITc2N6FJsUGGO9

oauth2Token = oauth_client.token.get_bearer_token('the authorization code returned from authorizationCodeUrl')
# => #<IntuitOAuth::ClientResponse:0x00007f9152b5c418 @access_token="the access token", @expires_in=3600, @refresh_token="the refresh token", @x_refresh_token_expires_in=8726400>

```
    
Issues and Contributions
------------------------

Please open an [issue](https://github.com/intuit/oauth-rubyclient/issues) on GitHub if you have a problem, suggestion, or other comment.

Pull requests are welcome and encouraged! Any contributions should include new or updated unit tests as necessary to maintain thorough test coverage.

License
-------

Intuit-oauth Ruby gem is provided under Apache 2.0 License
