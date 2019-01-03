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

require_relative './constants'
require_relative './transport'
require_relative './migration'
require_relative './flow/code'
require_relative './flow/token'
require_relative './flow/openid'


module IntuitOAuth
  class Client
    attr_reader :id, :secret, :redirect_uri, :environment,
    :auth_endpoint, :token_endpoint, :revoke_endpoint, :issuer_uri, :jwks_uri, :user_info_url, :state_token, :realm_id
    attr_writer :realm_id, :state_token

    def initialize(client_id, client_secret, redirect_uri, environment)
      @id = client_id
      @secret = client_secret
      @redirect_uri = redirect_uri
      @environment = environment

      # Discovery Doc containes endpoints required for OAuth fow
      @discovery_doc = get_discovery_doc(@environment)
      @auth_endpoint = @discovery_doc['authorization_endpoint']
      @token_endpoint = @discovery_doc['token_endpoint']
      @revoke_endpoint = @discovery_doc['revocation_endpoint']
      @issuer_uri = @discovery_doc['issuer']
      @jwks_uri = @discovery_doc['jwks_uri']
      @user_info_url = @discovery_doc['userinfo_endpoint']

      # optionally set realm_id
      @realm_id = ''
      @state_token = ''
    end

    def get_discovery_doc(environment)
      if ['production', 'prod'].include? environment.downcase
        url = IntuitOAuth::Config::DISCOVERY_URL_PROD
      else
        url = IntuitOAuth::Config::DISCOVERY_URL_SANDBOX
      end
      IntuitOAuth::Transport.request('GET', url)
    end

    def code
      IntuitOAuth::Flow::AuthCode.new(self)
    end

    def token
      IntuitOAuth::Flow::Token.new(self)
    end

    def openid
      IntuitOAuth::Flow::OpenID.new(self)
    end

    def migration
      IntuitOAuth::Migration::Migrate.new(self)
    end
  end
end
