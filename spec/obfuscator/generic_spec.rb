require 'spec_helper'

describe Obfuscator::Generic do
  before(:each) do
    class User < ActiveRecord::Base; end
    class Person < ActiveRecord::Base; end

    User.create!(login: "login", email: "email@example.com", password: "pword")
    User.create!(login: "login2", email: "email2@example.com", password: "pword")
  end

  let(:obfuscator) { Obfuscator::Generic.new }
  let(:first_user) { User.first }
  let(:last_user)  { User.last }

  describe ".scrub!" do
    context "given a model" do
      it "assigns @model to the given model name" do
        obfuscator.scrub!("Person")
        obfuscator.model.should == Person
      end
    end

    context "not given a model" do
      it "defaults to 'User'" do
        obfuscator.scrub!
        obfuscator.model.should == User
      end
    end

    context "given an array of columns" do
      it "updates the given columns for each record" do
        first_user.login.should == "login"
        last_user.login.should == "login2"

        obfuscator.scrub!("User", [:login])

        first_user.reload.login.should_not == "login"
        last_user.reload.login.should_not == "login2"
      end

      it "obfuscates the given columns with dummy data" do
        Faker::Lorem.should_receive(:sentence).any_number_of_times.
          and_return("The quick brown fox")

        first_user.should_receive(:update_attributes).
          with("email" => "The quick brown fox")

        obfuscator.scrub!("User", [:email])
      end

      context "given a string column" do
        context "not given a type parameter" do
          it "obfuscates the column with a dummy sentence" do
            Faker::Lorem.should_receive(:sentence).
              and_return("The quick brown fox")

            first_user.should_receive(:update_attributes).
              with("login" => "The quick brown fox")

            obfuscator.scrub!("User", [:login])
          end
        end

        context "given a type parameter" do
          context "given a user_name type parameter" do
            it "generates a plausible user_name" do
              Faker::Internet.should_receive(:user_name).
                any_number_of_times.
                and_return("bryanawesome")

              Faker::Internet.should_receive(:email).
                any_number_of_times.
                and_return("bryanawesome@example.com")

              obfuscator.scrub!("User", { login: :user_name, email: :email })
            end
          end
        end
      end
    end

    context "not given an array of columns" do
      it "returns nil" do
        obfuscator.scrub!("User").should be_nil
      end
    end
  end
end
