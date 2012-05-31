require 'spec_helper'

describe Obfuscator::Generic do
  before do
    class User < ActiveRecord::Base; end
    class Person < ActiveRecord::Base; end

    User.create!(login: "login", email: "email@gmail.com", password: "pword")
  end

  describe ".scrub!" do
    context "given a model" do
      it "assigns @model to the given model name" do
        obfuscator = Obfuscator::Generic.new
        obfuscator.scrub!("Person")
        obfuscator.model.should == Person
      end
    end

    context "not given a model" do
      it "defaults to 'User'" do
        obfuscator = Obfuscator::Generic.new
        obfuscator.scrub!
        obfuscator.model.should == User
      end
    end

    context "given an array of columns" do
      it "scrubs the provided columns for each record with dummy data" do
        obfuscator = Obfuscator::Generic.new
        user = User.last

        user.login.should == "login"

        obfuscator.scrub!("User", columns: [:login])

        user.reload.login.should_not == "login"
      end
    end
  end
end
