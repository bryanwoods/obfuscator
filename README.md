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

```ruby
# Without a format, Obfuscator will fill all of the given columns
# with dummy data based on the column's SQL type
Obfuscator.scrub! "Message" do
  # Would generate dummy sentences, paragraphs, and timestamps accordingly
  overwrite :title, :body, :created_at
end

# Currently any format from Faker::Internet
# (https://github.com/stympy/faker/blob/master/lib/faker/internet.rb)
# should work for when the generated data needs to be in a specific format
Obfuscator.scrub! "User" do
  overwrite :login do
    format :user_name
  end
end

Obfuscator.scrub! "Subscriber" do
  overwrite :email_address do
    format :email
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
