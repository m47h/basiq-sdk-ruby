# frozen_string_literal: true

folder = File.expand_path('.', __dir__)
$LOAD_PATH.unshift(folder) unless $LOAD_PATH.include?(folder)

require 'faraday'
require 'json'
require 'basiq/connection'
require 'basiq/http_error'
require 'basiq/job'
require 'basiq/session'
require 'basiq/transaction_list'
require 'basiq/user'
require 'basiq/services/connection_service'
require 'basiq/services/user_service'
require 'basiq/utils/filter_builder'

module Basiq
  class Api
    def initialize(host)
      host += '/' if host[-1] != '/'
      @host = host
      @headers = {}
      @request = ::Faraday.new(url: @host)
    end

    def header(header)
      @headers[header]
    end

    def set_header(header, value)
      @headers[header] = value
    end

    def post(endpoint, payload = {})
      response = @request.post(endpoint, payload.to_json, @headers)
      handle_response(response)
    end

    def get(endpoint)
      response = @request.get(endpoint, {}, @headers)
      handle_response(response)
    end

    def delete(endpoint)
      response = @request.delete(endpoint, {}, @headers)
      handle_response(response)
    end

    private

    def handle_response(response)
      raise HttpError, response if response.status > 299

      JSON.parse(response.body, symbolize_names: true)
    rescue JSON::ParserError
      response
    end
  end
end
