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
require 'httparty'
require_relative './utils'

module IntuitOAuth
  class Transport
    include HTTParty
    ssl_version :TLSv1_2

    def self.request(method, url, headers=nil, body=nil, isBuildResponse=true)
      uri = URI(url)

      user_agent_header = {
        'User-Agent': IntuitOAuth::Version::USER_AGENT
      }
      req_headers = headers.nil? ? user_agent_header : user_agent_header.merge!(headers)

      if method == 'GET'
        response = HTTParty.get(url,
          headers: req_headers
        )

      elsif method == 'POST'
        response = HTTParty.post(url,
          headers: req_headers,
          body: body
        )
      end

      if isBuildResponse == true
        IntuitOAuth::Utils.build_response_object(response)
      else
        response
      end
    end
  end
end
