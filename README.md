# Basiq.io Ruby SDK
This is the documentation for the Ruby SDK for Basiq.io API.

This SDK is compatible with Ruby 2.6

## Introduction

Basiq.io Ruby SDK is a set of tools you can use to easily communicate with Basiq API.
If you want to get familiar with the API docs, [click here](https://basiq.io/api/).

The SDK is organized to mirror the HTTP API's functionality and hierarchy.
The top level object needed for SDKs functionality is the Session
object which requires your API key to be instantiated.
You can grab your API key on the [dashboard](http://dashboard.basiq.io).

## Changelog

0.1.0 - Initial release

## Getting started

Add this line to your application's Gemfile:

```ruby
gem 'basiq', git: 'https://github.com/m47h/basiq-sdk-ruby'
```

And then execute:
```bash
$ bundle
```

Now that you have your API key, you can use the following command to install the SDK:

And input the endpoint you wish to target
```ruby
api = Basiq::Api.new('https://au-api.basiq.io')
```

## Common usage examples

### Fetching a list of institutions

You can fetch a list of supported financial institutions. The function returns a list of Institution structs.

```ruby
load 'lib/basiq.rb'

api = Basiq::Api.new('https://au-api.basiq.io')
session = Basiq::Session.new(api, 'YOUR_API_KEY')

institutions = session.get_institutions
```

You can specify the version of API when instantiating Session object.
Default: 2.0

```ruby
load 'lib/basiq.rb'

api = Basiq::Api.new('https://au-api.basiq.io')
session = Basiq::Session.new(api, 'YOUR_API_KEY', version: '1.0')

institutions = session.get_institutions
```

You can specify the scope access. SERVER_ACCESS with all grants and CLIENT_ACCESS which is restricted to creating connection, geting job status, getting_institutions, etc. but cannot create, update, delete users, getting accounts, etc.
Default: SERVER_ACCESS

```ruby
load 'lib/basiq.rb'

api = Basiq::Api.new('https://au-api.basiq.io')
session = Basiq::Session.new(api, 'YOUR_API_KEY', scope: 'CLIENT_ACCESS')

institutions = session.get_institutions
```

### Creating new user

```ruby
load 'lib/basiq.rb'

session = Basiq::Session.new(api, 'YOUR_API_KEY')
user_service = Basiq::UserService.new(session)

user = user_service.create(email: 'your@email.com', mobile: '+61410888666')
```

### Creating a new connection

When a new connection request is made, the server will create a job that will link user's financial institution with your app.

```ruby
load 'lib/basiq.rb'

api = Basiq::Api.new('https://au-api.basiq.io')
session = Basiq::Session.new(api, 'YOUR_API_KEY')

user = session.for_user(user_id)

job = user.create_connection(login: 'gavinBelson', password: 'hooli2016', institution_id: 'AU00000')

# Poll our server to wait for the credentials step to be evaluated
# Default: interval = 1000[ms] and timeout = 60[s]
connection = job.wait_for_credentials
```

### Fetching and iterating through transactions

In this example, the function returns a transactions list struct which is filtered by the connection.id property.
You can iterate through transactions list by calling `.next`.

```ruby
load 'lib/basiq.rb'

api = Basiq::Api.new('https://au-api.basiq.io')
session = Basiq::Session.new(api, 'YOUR_API_KEY', '2.0')

user = session.for_user(user_id)

filter = Basiq::FilterBuilder.new
filter.eq('connection.id', 'conn-id-213-id')
transactions_list = user.get_transactions(filter)

transactions_list.next
```

## API

The API of the SDK is manipulated using Services and Entities. Different
services return different entities, but the mapping is not one to one.

### Errors
If an action encounters an error, HttpError exception will be raised.

##### HttpError exception example
```ruby
Basiq::HttpError ({
  'type' => 'error',
  'code' => 'parameter-not-valid',
  'title' => 'Parameter value is not valid',
  'detail' => 'User ID value is not valid',
  'source' => { 'parameter' => 'userId' },
  'corelation_id' => 'faed7ced-ab13-4504-a1ad-734f60d9299c',
  'http_code' => '400'
})
```

Check the [docs](https://basiq.io/api/) for more information about relevant
fields in the error object.

### Filtering

Some of the methods support adding filters to them. The filters are created
using the FilterBuilder class. After instantiating the class, you can invoke
methods in the form of comparison(field, value).

Example:
```ruby
load 'lib/basiq.rb'

filter = Basiq::FilterBuilder.new
filter.eq('connection.id', 'conn-id-213-id').gt('transaction.postDate', '2018-01-01')
transactions = user.get_transactions(filter)
```

This example filter for transactions will match all transactions for the connection
with the id of 'conn-id-213-id' and that are newer than '2018-01-01'. All you have
to do is pass the filter instance when you want to use it.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
