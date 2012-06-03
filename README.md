# Obfuscator

Working from a production database dump can often be helpful for
debugging strange errors and edge cases, but having potentially
sensitive user data on a development machine is a dangerous liability.

Obfuscator provides a clean, friendly API for obfuscating sensitive
columns in your Ruby on Rails application's models.

## Installation

Add this line to your application's Gemfile:

    gem 'obfuscator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install obfuscator

## Usage

As a Ruby program:

```ruby
# Without a format, Obfuscator will fill all of the given columns
# with dummy data based on the column's SQL type
Obfuscator.scrub! "Message" do
  overwrite :title, :body, :created_at
end

# Currently any format from Faker::Internet
# (https://github.com/stympy/faker/blob/master/lib/faker/internet.rb)
# should work for when the generated data needs to be in a specific format
Obfuscator.scrub! "User" do
  overwrite :login do
    format :user_name
  end

  overwrite :email_address do
    format :email
  end
end
```

Or as a Rake task:

    rake obfuscator:scrub[User] COLUMNS=login,email

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

* Reflect on model validations to ensure generated data is valid
* Make DSL more flexible about taking both arrays and hashes of columns
  with options
* Move away from iterating through batches of records and calling
  update_attributes by constructing an update_all
