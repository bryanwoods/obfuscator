require "obfuscator/version"

module Obfuscator
  class Generic
    attr_accessor :model, :columns

    def scrub!(model_name = "User", options = {})
      @model = model_name.constantize
      @columns = options[:columns]

      if @columns.present?
        attributes = Hash[@columns.map { |k| [k, "foo"] }]
      else
        attributes = {}
      end

      @model.all.each do |m|
        m.update_attributes(attributes)
      end
    end
  end
end
