# frozen_string_literal: true

module Basiq
  class UserService
    attr_reader :session

    def initialize(session)
      @session = session
    end

    def for_user(user_id)
      User.new(self).for_user(user_id)
    end

    def get(user_id)
      response = @session.api.get('users/' + user_id)
      create_user(response)
    end

    def create(email: nil, mobile: nil)
      response = @session.api.post('users/', payload(email, mobile))
      create_user(response)
    end

    def update(user_id, email: nil, mobile: nil)
      response = @session.api.post('users/' + user_id, payload(email, mobile))
      create_user(response)
    end

    def delete(user_id)
      @session.api.delete('users/' + user_id)
    end

    def refresh_all_connections(user_id)
      @session.api.post('users/' + user_id + '/connections/refresh')
    end

    def list_all_connections(user_id, filter = nil)
      url = append_filter_to_url('users/' + user_id + '/connections', filter)
      @session.api.get(url)
    end

    def get_transaction(user_id, transaction_id)
      @session.api.get('users/' + user_id + '/transactions/' + transaction_id)
    end

    def get_transactions(user_id, filter = nil)
      url = append_filter_to_url('users/' + user_id + '/transactions', filter)
      transactions = @session.api.get(url)
      TransactionList.new(self, transactions)
    end

    def get_account(user_id, account_id)
      @session.api.get('users/' + user_id + '/accounts/' + account_id)
    end

    def get_accounts(user_id, filter = nil)
      url = append_filter_to_url('users/' + user_id + '/accounts', filter)
      @session.api.get(url)
    end

    private

    def payload(email, mobile)
      payload = {}
      raise ArgumentError, 'Neither email or mobile were provided' if email.nil? && mobile.nil?

      payload['email'] = email unless email.nil?
      payload['mobile'] = mobile unless mobile.nil?
      payload
    end

    def create_user(response)
      user = User.new(self)
      user.id = response[:id]
      user.email = response[:email]
      user.mobile = response[:mobile]
      user
    end

    def append_filter_to_url(url, filter)
      return url if filter.nil?

      unless filter.is_a? FilterBuilder
        raise ArgumentError, 'Provided filter must be an instance of FilterBuilder class'
      end

      url + '?' + filter.get_filter
    end
  end
end
