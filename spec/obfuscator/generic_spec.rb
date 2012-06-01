require 'spec_helper'

describe Obfuscator::Generic do
  before(:all) do
    class User < ActiveRecord::Base; end
    class Person < ActiveRecord::Base; end
  end

  before(:each) do
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

      context "given a text column" do
        let(:paragraph) do
          "A slightly long section of text, one that would perhaps be too
          long to be stored as a string and might therefore be better stored
          as a text blizzle bluzzle."
        end

        it "obfuscates the column with a dummy paragraph" do
          Faker::Lorem.should_receive(:paragraph).any_number_of_times.
            and_return(paragraph)

          last_user.should_receive(:update_attributes).with("bio" => paragraph)

          obfuscator.scrub!("User", [:bio])
        end
      end

      context "given an integer column" do
        it "obfuscates the column with a dummy number" do
          obfuscator.should_receive(:random_number).any_number_of_times.
            with(10).and_return(9)

          first_user.should_receive(:update_attributes).with("id" => 9)

          obfuscator.scrub!("User", [:id])
        end
      end

      context "given a string column" do
        context "not given a type parameter" do
          it "obfuscates the column with a dummy sentence" do
            Faker::Lorem.should_receive(:sentence).any_number_of_times.
              and_return("The quick brown fox")

            first_user.should_receive(:update_attributes).
              with("login" => "The quick brown fox")

            obfuscator.scrub!("User", [:login])
          end

          it "generates unique dummy sentences" do
            obfuscator.scrub!("User", [:login])

            first_user.reload.login.should_not == last_user.reload.login
          end
        end

        context "given a type parameter" do
          context "given valid type parameters" do
            it "generates a plausible user_name" do
              Faker::Internet.should_receive(:user_name).
                any_number_of_times.
                and_return("bryanawesome")

              Faker::Internet.should_receive(:email).
                any_number_of_times.
                and_return("bryanawesome@example.com")

              obfuscator.scrub!("User", { login: :user_name, email: :email })
            end

            context "given an invalid type parameter" do
              it "raises an UnkownObfuscationTypeError" do
                expect { obfuscator.scrub!("User", { login: :invalid_type }) }.
                  to raise_error(
                    Obfuscator::Generic::UnkownObfuscationTypeError
                  )
              end
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

  describe "#random_number" do
    it "returns a random number" do
      0.upto(9).to_a.should include(obfuscator.random_number(10))
    end
  end
end
