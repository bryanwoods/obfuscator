require 'spec_helper'

describe Obfuscator::Utilities do
  describe ".random_number" do
    it "returns a random number" do
      0.upto(9).to_a.should include(Obfuscator::Utilities.random_number(10))
    end
  end

  describe ".random_boolean" do
    it "randomly returns true or false" do
      [true, false].should include(Obfuscator::Utilities.random_boolean)
    end
  end

  describe ".random_date" do
    it "returns a random date" do
      Obfuscator::Utilities.random_date.should be_kind_of(Date)
    end
  end
end
