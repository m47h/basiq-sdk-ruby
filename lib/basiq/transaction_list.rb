# frozen_string_literal: true

module Basiq
  class TransactionList
    attr_reader :data

    def initialize(service, data)
      @data = data
      @service = service
    end

    def next
      if @data[:links] && @data[:links][:next]
        next_link = @data[:links][:next]
        next_path = next_link[next_link.rindex('.io/') + 4..-1]
        @data = @service.session.api.get(next_path)
        return self
      end

      nil
    end
  end
end
