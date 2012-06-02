module Obfuscator
  module Dsl
    module ClassMethods
      def scrub!(model, &block)
        instance_eval(&block)

        obfuscator = Obfuscator::Generic.new

        obfuscator.scrub!(model, columns)
      end

      def overwrite(*columns, &block)
        if block_given?
          @columns = columns

          return instance_eval(&block)
        end

        if columns.length == 1
          @columns.push(columns.first)
        else
          @columns.push(columns)
        end
      end

      def columns
        if @columns.is_a?(Array)
          @columns.flatten.uniq
        else
          @columns
        end
      end

      def format(format)
        @columns = { columns.first => format }
      end
    end

    def self.included(base)
      base.extend(ClassMethods)

      base.module_eval do
        @columns = []
      end
    end
  end
end
