# frozen_string_literal: true

module Basiq
  class Job
    attr_accessor :id, :links, :steps, :created, :updated

    def initialize(connection_service)
      @connection_service = connection_service
    end

    def for_job(id)
      @id = id
      self
    end

    def get_connection_id
      return '' if @links.nil?
      return '' if @links[:source].nil? || @links[:source].empty?

      @links[:source][@links[:source].rindex('/') + 1..-1]
    end

    def get_connection
      job = if get_connection_id.empty?
              @connection_service.get_job(@id)
            else
              self
            end

      @connection_service.get(job.get_connection_id)
    end

    def wait_for_credentials(interval = 1000, timeout = 60, i = 0)
      job = @connection_service.get_job(@id)

      handle_job(job.get_connection_id, job.steps[0], interval, timeout, i) do
        wait_for_credentials(interval, timeout, i + 1)
      end
    end

    def wait_for_accounts(interval = 1000, timeout = 60, i = 0)
      job = @connection_service.get_job(@id)

      handle_job(job.get_connection_id, job.steps[1], interval, timeout, i) do
        wait_for_accounts(interval, timeout, i + 1)
      end
    end

    def wait_for_transactions(interval = 1000, timeout = 60, i = 0)
      job = @connection_service.get_job(@id)

      handle_job(job.get_connection_id, job.steps[2], interval, timeout, i) do
        wait_for_transactions(interval, timeout, i + 1)
      end
    end

    private

    def handle_job(job_connection_id, step, interval, timeout, i, &block)
      return false if i * (interval / 1000) > timeout

      sleep(interval / 1000)

      return @connection_service.get(job_connection_id) if step[:status] == 'success'
      return false if step[:status] == 'failed'

      yield
    end
  end
end
