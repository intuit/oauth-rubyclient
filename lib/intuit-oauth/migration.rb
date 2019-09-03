# Copyright (c) 2018 Intuit
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative './utils'
require_relative './transport'
require_relative './constants'
require_relative './base'


module IntuitOAuth
  module Migration
    class Migrate < Base
      
      # Exchange an OAuth 1 token for an OAuth 2 token pair. It is used for apps that are using OAuth 1.0 and want to migrate
      # to OAuth 2.0.
      #
      # @param [cusomer_key] the OAuth 1.0 Consumer key
      # @param [consumer_secret] the OAuth 1.0 Consumer Secret
      # @param [access_token] the OAuth 1.0 Access Token
      # @param [access_secret] the OAuth 1.0 Access Token Secret
      # @param [scopes] the scopes for the token.
      # @return [OAuth2Token] the OAuth2 Token object
      def migrate_tokens(consumer_key, consumer_secret, access_token, access_secret, scopes)
        if %w[production prod].include? @client.environment.downcase
          migration_endpoint = IntuitOAuth::Config::MIGRATION_URL_PROD
        else
          migration_endpoint = IntuitOAuth::Config::MIGRATION_URL_SANDBOX
        end

        oauth1_tokens = {
          consumer_key: consumer_key,
          consumer_secret: consumer_secret,
          access_token: access_token,
          access_secret: access_secret
        }
        oauth1_header = IntuitOAuth::Utils.get_oauth1_header('POST', migration_endpoint, oauth1_tokens)
        headers = {
          'Content-Type': 'application/json',
          Accept: 'application/json',
          Authorization: oauth1_header
        }

        body = {
          scope: IntuitOAuth::Utils.scopes_to_string(scopes),
          redirect_uri: @client.redirect_uri,
          client_id: @client.id,
          client_secret: @client.secret
        }

        IntuitOAuth::Transport.request('POST', migration_endpoint, headers, body)
      end

    end
  end
end
