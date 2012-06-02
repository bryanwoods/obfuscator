$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'sqlite3'
require 'active_record'
require 'faker'
require 'pry'

require 'obfuscator'

RSpec.configure do |config|
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :email
    t.string :login
    t.string :password
    t.text   :bio
    t.datetime :birthdate
  end

  create_table :people, force: true do |t|
    t.string :email
    t.string :login
    t.string :password
    t.boolean :good_looking
  end
end

class User < ActiveRecord::Base; end
class Person < ActiveRecord::Base; end
