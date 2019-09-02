# frozen_string_literal: true

module Basiq
  class HttpError < StandardError
    def initialize(response)
      http_code = response.status.to_s
      response = JSON.parse(response.body)
      data = response['data'].first
      data['corelation_id'] = response['correlationId']
      data['http_code'] = http_code
      super(data)
    end
  end
end
