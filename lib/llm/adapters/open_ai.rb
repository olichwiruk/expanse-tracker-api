# frozen_string_literal: true

module Llm
  module Adapters
    class OpenAi
      attr_reader :client

      def initialize(api_key: ENV.fetch("OPENAI_API_KEY", nil), default_model: "gpt-5-nano")
        @client = RubyLLM.context do |config|
          config.openai_api_key = api_key
          config.default_model = default_model
        end
      end

      def extract_structured_data(image:, schema: ::Receipts::ExtractedData)
        chat = client.chat.with_instructions(
          "You are an engine for extracting data from receipt images"
        )
          .with_schema(Llm::SchemaGenerator.call(schema))

        response = chat
          .ask(
            "Extract merchant data, all items with full names and assign category",
            with: image
          )

        response.content
      end
    end
  end
end
