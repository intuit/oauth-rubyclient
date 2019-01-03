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

module IntuitOAuth
  class ClientResponse
    attr_reader :access_token, :expires_in, :refresh_token, :x_refresh_token_expires_in,
    :id_token, :headers, :body, :code, :realm_id

    def initialize(response)
      @access_token = response['access_token']
      @expires_in = response['expires_in']
      @refresh_token = response['refresh_token']
      @x_refresh_token_expires_in = response['x_refresh_token_expires_in']
      if response['id_token']
        @id_token = response['id_token']
      end
      if response['realmId']
        @realm_id = response['realmId']
      end

      @headers = response.headers
      @body = response
      @code = response.code
    end
  end
end
