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

require 'base64'
require 'active_support/all'
require 'cgi'
require 'openssl'
require_relative './response'
require_relative './exception'

module IntuitOAuth
  class Utils
    def self.scopes_to_string(scopes)
      scopes_str = scopes.join(' ')
      scopes_str.chomp(' ')
    end

    def self.get_auth_header(client_id, client_secret)
      encoded = Base64.strict_encode64("#{client_id}:#{client_secret}")
      "Basic #{encoded}"
    end

    def self.generate_random_string(length=20)
      Array.new(length){[*'A'..'Z', *'0'..'9', *'a'..'z'].sample}.join
    end

    def self.get_oauth1_header(method, uri, oauth1_tokens, uri_params={})
      params = {
        oauth_consumer_key: oauth1_tokens[:consumer_key],
        oauth_token: oauth1_tokens[:access_token],
        oauth_signature_method: 'HMAC-SHA1',
        oauth_timestamp: Time.now.getutc.to_i.to_s,
        oauth_nonce: generate_random_string(7),
        oauth_version: '1.0'
      }

      all_params = params.merge(uri_params).sort.to_h
      base_string = "#{method.upcase}&#{CGI.escape(uri)}&#{CGI.escape(all_params.to_param)}"
      key = "#{oauth1_tokens[:consumer_secret]}&#{oauth1_tokens[:access_secret]}"

      signature = CGI.escape(Base64.strict_encode64(OpenSSL::HMAC.digest('sha1', key, base_string).to_s))
      params[:oauth_signature] = signature
      "OAuth #{format_string_delimiter(params, ',', true)}"
    end

    def self.format_string_delimiter(params, delimiter, with_quotes=false)
      if with_quotes
        return params.map { |k, v| "#{k}=\"#{v}\"" }.join(delimiter)
      end
      params.map { |k, v| "#{k}=#{v}" }.join(delimiter)
    end

    def self.build_response_object(response)
      url = response.request.last_uri.to_s
      if response.code != 200
        raise OAuth2ClientException.new(response)
      elsif url['openid_sandbox_configuration'] || url['openid_configuration'] || url['openid_connect/userinfo']
        response
      else
        IntuitOAuth::ClientResponse.new(response)
      end
    end
  end
end
