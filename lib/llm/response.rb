# frozen_string_literal: true

module Llm
  module Types
    include Dry.Types()
  end

  class Response < Dry::Struct
    attribute :vendor,            Types::String
    attribute :model,             Types::String
    attribute :content,           Types::Hash | Types::String
    attribute :request_payload,   Types::Hash
    attribute :response_payload,  Types::Hash
    attribute :input_tokens,     Types::Integer.optional.default(nil)
    attribute :output_tokens, Types::Integer.optional.default(nil)
    attribute :duration_ms,       Types::Integer
  end
end
