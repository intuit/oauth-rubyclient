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

require 'rsa_pem'

require_relative '../base'


module IntuitOAuth
  module Flow
    class OpenID < Base

      # Get the User Info
      #
      # @param [access_token] the access token needs to access the user info
      # @return [Response] the response object
      def get_user_info(access_token)
        headers = {
          Authorization: "Bearer #{access_token}"
        }

        IntuitOAuth::Transport.request('GET', @client.user_info_url, headers=headers)
      end

      ##
      #  If the token can be correctly validated, returns True. Otherwise, return false
      #  The validation rules are:
      #  1.You have to provide the client_id value, which must match the
      #  token's aud field
      #  2.The payload issuer is from Intuit
      #  3.The expire time is not expired.
      #  4.The signature is correct
      #
      # If something fails, raises an error
      #
      # @param [String] id_token
      #   The string form of the token
      #
      # @return [Boolean]

      def validate_id_token(id_token)

        id_token_header_raw, id_token_payload_raw, id_token_signature_raw = id_token.split(".")

        # base 64 decode
        id_token_header_json = JSON.parse(Base64.decode64(id_token_header_raw.strip))
        id_token_payload_json = JSON.parse(Base64.decode64(id_token_payload_raw.strip))
        id_token_signature = Base64.decode64(id_token_signature_raw.strip)

        # 1. check if payload's issuer is from Intuit
        issue = id_token_payload_json.fetch('iss')
        unless issue.eql? @client.issuer_uri
          return false
        end

        # 2. check if the aud matches the client id
        aud = id_token_payload_json.fetch('aud').first
        unless aud.eql? @client.id
          return false
        end

        # 3. check if the expire time is not expired
        exp = id_token_payload_json.fetch('exp')
        if exp < Time.now.to_i
          return false
        end

        # 4. check if the signature is correct
        response = IntuitOAuth::Transport.request('GET', @client.jwks_uri, nil, nil, false)
        body = response.body

        keys = JSON.parse(body).fetch('keys').first
        standard_kid = keys.fetch('kid')
        kid_in_id_token = id_token_header_json.fetch('kid')

        unless standard_kid.eql? kid_in_id_token
          return false
        end

        return true

        end
    end
  end
end
