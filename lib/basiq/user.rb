# frozen_string_literal: true

module Basiq
  class User
    attr_accessor :id, :email, :mobile

    def initialize(user_service)
      @user_service = user_service
    end

    def for_user(id)
      @id = id
      get
      self
    end

    def get
      response = @user_service.get(@id)
      @email = response.email
      @mobile = response.mobile
      self
    end

    def update(email: nil, mobile: nil)
      @user_service.update(@id, email: email, mobile: mobile)
    end

    def delete
      @user_service.delete(@id)
    end

    def create_connection(data)
      ConnectionService.new(@user_service.session, self).create(data)
    end

    def refresh_all_connections
      @user_service.refresh_all_connections(@id)
    end

    def list_all_connections(filter = nil)
      @user_service.list_all_connections(@id, filter)
    end

    def get_transaction(transaction_id)
      @user_service.get_transaction(@id, transaction_id)
    end

    def get_transactions(filter = nil)
      @user_service.get_transactions(@id, filter)
    end

    def get_account(account_id)
      @user_service.get_account(@id, account_id)
    end

    def get_accounts(filter = nil)
      @user_service.get_accounts(@id, filter)
    end
  end
end
