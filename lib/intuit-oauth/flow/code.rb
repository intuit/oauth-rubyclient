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

require_relative '../base'
require_relative '../utils'
require 'active_support/all'


module IntuitOAuth
  module Flow
    class AuthCode < Base

      # Generate the Authorization Code URL
      #
      # @param [Scope] the Scope for the token to be generated
      # @param [state_token] an option state token to be passed
      # @return [URL] the authorization code URL
      def get_auth_uri(scopes, state_token=nil)
        if state_token.nil?
          state_token = IntuitOAuth::Utils.generate_random_string()
        end
        @client.state_token = state_token
        url_params = {
          client_id: @client.id,
          scope: IntuitOAuth::Utils.scopes_to_string(scopes),
          redirect_uri: @client.redirect_uri,
          response_type: 'code',
          state: state_token,
          claims: '{"id_token":{"realmId":null}}',
        }

        "#{@client.auth_endpoint}?#{url_params.to_param}"
      end
    end
  end
end
