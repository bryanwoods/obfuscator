module Obfuscator
  class Generic
    attr_accessor :model, :columns

    def scrub!(model_name = "User", columns = [])
      @model = model_name.constantize

      if columns.is_a?(Hash)
        columns.each do |key, value|
          instance_variable_set("@#{key}_type", value)
        end

        @columns = columns.keys
      else
        @columns = columns
      end

      @columns.map!(&:to_s)

      return unless @columns.any?

      attributes = model_columns_contain_given? ?
        columns_with_obfuscated_values_hash : {}

      @model.all.each do |m|
        m.update_attributes(attributes)
      end
    end

    private

    def model_columns_contain_given?
      (@model.columns_hash.keys | @columns).any?
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
          @value = Faker::Lorem.sentence
          @result = Hash[@columns.map { |key| [key, @value] }]
        end
      end

      @result
    end
  end
end
