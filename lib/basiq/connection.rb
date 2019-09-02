# frozen_string_literal: true

module Basiq
  class Connection
    attr_accessor :id, :status, :last_used, :institution, :accounts, :links

    def initialize(connection_service)
      @connection_service = connection_service
    end

    def for_connection(id)
      @id = id
      self
    end

    def refresh
      @connection_service.refresh(@id)
    end

    def update(password)
      @connection_service.update(@id, password)
    end

    def delete
      @connection_service.delete(@id)
    end
  end
end
