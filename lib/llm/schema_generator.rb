# frozen_string_literal: true

module Llm
  class SchemaGenerator
    def self.call(struct_class)
      {
        name: struct_class.name.demodulize.underscore,
        strict: true,
        schema: generate_object_schema(struct_class)
      }
    end

    private_class_method def self.generate_object_schema(struct_class)
      properties = {}
      required = []

      struct_class.schema.keys.each do |key|
        name = key.name.to_s
        required << name
        properties[name] = map_type(key.type)
      end

      {
        type: "object",
        properties: properties,
        required: required,
        additionalProperties: false
      }
    end

    private_class_method def self.map_type(dry_type)
      primitive = dry_type.primitive

      result =
        if primitive.is_a?(Class) && primitive < Dry::Struct
          generate_object_schema(primitive)
        else
          case primitive.to_s
          when "String"
            { type: "string" }
          when "Integer"
            { type: "integer" }
          when "Float", "BigDecimal"
            { type: "number" }
          when "TrueClass", "FalseClass"
            { type: "boolean" }
          when "Array"
            {
              type: "array",
              items: map_type(dry_type.member)
            }
          else
            { type: "string" }
          end
        end

      if dry_type.meta.is_a?(Hash) && dry_type.meta[:description]
        result[:description] = dry_type.meta[:description]
      end

      result
    end
  end
end
