require 'spec_helper'

describe Obfuscator::Dsl do
  before(:each) do
    Obfuscator::Dsl.instance_variable_set(:@columns, [])

    User.create!(
      login: "login",
      email: "email@example.com",
      password: "pword",
      birthdate: 20.years.ago
    )

    User.create!(
      login: "login2",
      email: "email2@example.com",
      password: "pword"
    )
  end

  describe ".scrub!" do
    it "Scrubs the model with the columns given in a block" do
      Obfuscator::Generic.any_instance.should_receive(:scrub!).
        with("User", [:login, :email])

      Obfuscator.scrub!("User") do
        overwrite :login
        overwrite :email
      end
    end
  end

  describe ".overwrite" do
    context "given one column" do
      it "stores the given column in an array" do
        Obfuscator.overwrite(:login)
        Obfuscator.overwrite(:email)
        Obfuscator.overwrite(:birth_date)

        Obfuscator.send(:columns).should == [:login, :email, :birth_date]
      end

      context "given more than one column" do
        it "stores the given columns in an array" do
          Obfuscator.overwrite(:login, :email, :birth_date)

          Obfuscator.send(:columns).should == [:login, :email, :birth_date]
        end
      end
    end
  end

  describe ".format" do
    it "sets the type of the column to the given format" do
      Obfuscator::Generic.any_instance.should_receive(:scrub!).
        with("User", { login: :user_name, email: :email })

      Obfuscator.scrub!("User") do
        overwrite :login do
          format :user_name
        end

        overwrite :email do
          format :email
        end
      end
    end
  end
end
