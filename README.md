# EasyMeli

A simple gem to access low level MercadoLibre api calls.

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

```
EasyMeli.configure do |config|
  config.application_id’ = ''
  config.secret_key = ''
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/easybroker/easy_meli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
