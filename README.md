# EasyMeli

A simple gem to access low level MercadoLibre api calls. This is the draft beta version.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy_meli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy_meli

## Usage

Configure the gem with your application ID and secret key.

```ruby
EasyMeli.configure do |config|
  config.application_id = 'your_app_id'
  config.secret_key = 'your_secret_key'
end
```

To get the authorization url that the end-user uses to give your app authorization to access MercadoLibre on your part call the `authorization_url` with the desired country and the url to redirect to in order to complete the authorization.

```ruby
EasyMeli.authorization_url('MX', 'your_redirect_url')
```

Once MercadoLibre calls your redirect url you can get a refresh token by calling

```ruby
response = EasyMeli.create_token('the_code_in_the_redirect', 'the_same_redirect_url_as_above')
```
This will return a response object with a json body that you can easily access via `response.to_h`.

If you want to refresh the token call 

```ruby
access_token = EasyMeli.refresh_token('a_refresh_token')
```

Once you can have an access token you can create a client and call the supported http verb methods.

```ruby
client = EasyMeli.api_client(refresh_token: refresh_token)

client.get(path, query: { a: 1 })
client.post(path, query: { a: 1 }, body: { b: 1 })
client.put(path, query: { a: 1 }, body: { b: 1 })
client.delete(path, query: { a: 1 })
```

You can also pass a logger to any methods that make remote calls. The logger class must implement a `log` method which will be called with the [HTTParty response](https://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/Response) for every remote request sent.

```ruby
EasyMeli.create_token('the_code_in_the_redirect', 'the_same_redirect_url_as_above', logger: my_logger)
EasyMeli.api_client(refresh_token: refresh_token, logger: my_logger)
```

### Example of how to retrieve a user profile
```ruby
EasyMeli.configure do |config|
  config.application_id = "your_app_id"
  config.secret_key = "your_secret_key"
end

api_client = EasyMeli.api_client(refresh_token: refresh_token)
response = api_client.get('/users/me')

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/easybroker/easy_meli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
