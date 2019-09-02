# frozen_string_literal: true

module Basiq
  class ConnectionService
    attr_reader :session

    def initialize(session, user)
      @session = session
      @user = user
    end

    def for_connection(id)
      Connection.new(self).for_connection(id)
    end

    def get(connection_id)
      response = @session.api.get('users/' + @user.id + '/connections/' + connection_id)

      connection = Connection.new(self)
      connection.id = response[:id]
      connection.status = response[:status]
      connection.last_used = response[:lastUsed]
      connection.institution = response[:institution]
      connection.accounts = response[:accounts]
      connection.links = response[:links]
      connection
    end

    def get_job(job_id)
      response = @session.api.get('jobs/' + job_id)

      job = Job.new(self)
      job.id = response[:id]
      job.created = response[:created]
      job.updated = response[:updated]
      job.links = response[:links]
      job.steps = response[:steps] if response[:steps]
      job
    end

    def create(login:, password:, institution_id:)
      raise ArgumentError, 'Login id needs to be suplied' if login.nil? || login.empty?
      raise ArgumentError, 'Password id needs to be suplied' if password.nil? || password.empty?
      raise ArgumentError, 'Institution id needs to be suplied' if institution_id.nil? || institution_id.empty?

      payload = {
        loginId: login,
        password: password,
        institution: {
          id: institution_id
        }
      }

      response = @session.api.post('users/' + @user.id + '/connections', payload)
      create_job(response)
    end

    def update(connection_id, password, security_code = nil, secondary_login_id = nil)
      data = { 'password': password }
      data['securityCode'] = security_code unless security_code.nil?
      data['secondaryLoginId'] = secondary_login_id unless secondary_login_id.nil?

      response = @session.api.post('users/' + @user.id + '/connections/' + connection_id, data)
      create_job(response)
    end

    def delete(connection_id)
      @session.api.delete('users/' + @user.id + '/connections/' + connection_id)
    end

    def refresh(connection_id)
      response = @session.api.post('users/' + @user.id + '/connections/' + connection_id + '/refresh')
      create_job(response)
    end

    private

    def create_job(response)
      job = Job.new(self)
      job.id = response[:id]
      job
    end
  end
end
