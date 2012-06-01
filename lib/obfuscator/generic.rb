module Obfuscator
  class Generic
    class UnkownObfuscationTypeError < StandardError; end

    attr_accessor :model, :columns

    def random_number(limit)
      rand(limit)
    end

    def scrub!(model_name = "User", columns = [])
      @model = model_name.constantize

      if columns.is_a?(Hash)
        store_types_from_column_values(columns)
        @columns = columns.keys
      else
        @columns = columns
      end

      return unless @columns.any? and @columns.map!(&:to_s)

      scrub_all_records!
    end

    private

    def model_columns_contain_given?
      (@model.columns_hash.keys | @columns).any?
    end

    def store_types_from_column_values(columns)
      columns.each do |key, value|
        instance_variable_set("@#{key}_type", value)
      end
    end

    def columns_with_obfuscated_values_hash
      result_hash = {}

      @columns.each do |column|
        type = instance_variable_get("@#{column}_type")

        if type.present?
          if Faker::Internet.respond_to?(type)
            result_hash[column] = Faker::Internet.send(type)
            @result = result_hash
          else
            raise UnkownObfuscationTypeError.new("[#{type}] is an unknown type")
          end
        else
          derive_value_from_type(@model.columns_hash[column].type)

          @result = Hash[@columns.map { |key| [key, @value] }]
        end
      end

      @result
    end

    def derive_value_from_type(sql_type)
      default  = Faker::Lorem.sentence

      case sql_type
      when :string
        @value = default
      when :text
        @value = Faker::Lorem.paragraph
      when :integer
        @value = random_number(10)
      end
    end

    def scrub_all_records!
      attributes = model_columns_contain_given? ?
        columns_with_obfuscated_values_hash : {}

      @model.all.each do |m|
        m.update_attributes(attributes)
      end
    end
  end
end
