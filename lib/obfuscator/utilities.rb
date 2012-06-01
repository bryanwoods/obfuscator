module Obfuscator
  class Utilities
    class << self
      def random_number(limit)
        rand(limit)
      end

      def random_boolean
        [true, false].sample
      end

      def random_date
        month, day, year = rand(12) + 1, rand(28) + 1, (1980..2012).to_a.sample

        Date.parse("#{day}/#{month}/#{year}")
      end
    end
  end
end
