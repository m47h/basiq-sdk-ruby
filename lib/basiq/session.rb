# frozen_string_literal: true

module Basiq
  class Session
    attr_reader :api, :scope, :token

    def initialize(api, api_key, version: '2.0', scope: 'SERVER_ACCESS')
      @api_key = api_key
      @api = api
      @version = version
      @scope = scope
      @validity = nil
      @refreshed = nil
      @token = nil
      @headers = nil
      get_token
    end

    def get_token
      return @token if !@validity.nil? && Time.now - @refreshed < @validity
      return print 'Provided version not available' if @version != '1.0' && @version != '2.0'

      @api.set_header('Authorization', 'Basic ' + @api_key)
      @api.set_header('basiq-version', @version)
      @api.set_header('Content-Type', 'application/json')
      response = @api.post('token', scope: @scope)
      if response[:access_token]
        @api.set_header('Authorization', 'Bearer ' + response[:access_token])
        @refreshed = Time.now
        @validity = response[:expires_in]
        @token = response[:access_token]
      else
        print('No access token: ', response)
      end
    end

    def get_institutions
      @api.get('institutions')
    end

    def get_institution(id)
      @api.get('institutions/' + id)
    end

    def get_user(id)
      UserService.new(self).get(id)
    end

    def for_user(id)
      UserService.new(self).for_user(id)
    end
  end
end
