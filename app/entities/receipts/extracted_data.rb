# frozen_string_literal: true

module Receipts
  module Types
    include Dry.Types()
  end

  class Merchant < Dry::Struct
    transform_keys(&:to_sym)
    schema schema.strict

    attribute :name, Types::String
    attribute :address, Types::String
  end

  class Item < Dry::Struct
    transform_keys(&:to_sym)
    schema schema.strict

    attribute :raw_name, Types::String.meta(
      description: "The exact text as it appears on the receipt"
    )

    attribute :full_name, Types::String.meta(
      description: "The full, human-readable product name expanded from abbreviations (e.g., expand 'MLEK SOJ' to 'Mleko Sojowe' or 'CHLEB RAZ' to 'Chleb Razowy')"
    )

    attribute :category, Types::String
    attribute :quantity, Types::Coercible::Float

    attribute :price, Types::Coercible::Float.meta(
      description: "Unit price or total price for the item"
    )
  end

  class ExtractedData < Dry::Struct
    transform_keys(&:to_sym)
    schema schema.strict

    attribute :merchant, Merchant

    attribute :date, Types::String.meta(
      description: "The date of the receipt in ISO 8601 format"
    )

    attribute :items, Types::Array.of(Item)
    attribute :total_price, Types::Coercible::Float
  end
end
