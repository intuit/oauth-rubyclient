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

require 'uri'
require 'json'
require_relative '../utils'
require_relative '../transport'
require_relative '../base'


module IntuitOAuth
  module Flow
    class Token < Base

      # Exchange the authorization Code for the Bearer Token
      #
      # @param [auth_code] the Code send to your redirect_uri
      # @param [realm_id] the company ID for the Company
      # @return [AccessToken] the AccessToken
      def get_bearer_token(auth_code, realm_id=nil)
        if realm_id != nil
          @client.realm_id = realm_id
        end

        headers = {
          Accept: 'application/json',
          "Content-Type": 'application/x-www-form-urlencoded',
          Authorization: IntuitOAuth::Utils.get_auth_header(@client.id, @client.secret)
        }

        body = {
          grant_type: 'authorization_code',
          code: auth_code,
          redirect_uri: @client.redirect_uri
        }

        IntuitOAuth::Transport.request('POST', @client.token_endpoint, headers, URI.encode_www_form(body))
      end

      # Using the token passed to generate a new refresh token and access token
      #
      # @param [token] the refresh token used to refresh token
      # @return [AccessToken] the AccessToken
      def refresh_tokens(token)
        headers = {
          "Content-Type": 'application/x-www-form-urlencoded',
          Authorization: IntuitOAuth::Utils.get_auth_header(@client.id, @client.secret)
        }

        body = {
          grant_type: 'refresh_token',
          refresh_token: token
        }

        IntuitOAuth::Transport.request('POST', @client.token_endpoint, headers, URI.encode_www_form(body))
      end

      # Revoke the specific access token or refresh token. Return true if success, false otherwise
      #
      # @param [token] the refresh token or access token to be invoked
      # @return [boolean] True if successfully revoked. False otherwise
      def revoke_tokens(token)
        headers = {
          "Content-Type": 'application/json',
          Authorization: IntuitOAuth::Utils.get_auth_header(@client.id, @client.secret)
        }

        body = {
          token: token
        }

        response = IntuitOAuth::Transport.request('POST', @client.revoke_endpoint, headers, body.to_json, false)
        if response.code == 200
          return true
        end

        return false
      end

    end
  end
end
