# frozen_string_literal: true

module Llm
  module Adapters
    class OpenAi
      attr_reader :client, :model

      def initialize(api_key: ENV.fetch("OPENAI_API_KEY", nil), default_model: "gpt-5-nano")
        @model = default_model
        @client = RubyLLM.context do |config|
          config.openai_api_key = api_key
          config.default_model = @model
        end
      end

      def extract_structured_data(image:, schema: ::Receipts::ExtractedData)
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        chat = client.chat.with_instructions(
          "You are an engine for extracting data from receipt images"
        )
          .with_schema(Llm::SchemaGenerator.call(schema))

        response = chat
          .ask(
            "Extract merchant data, all items with full names and assign category",
            with: image
          )

        end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        request_body = JSON.parse(response.raw.env.request_body)
        cleaned_body = request_body.deep_transform_values do |value|
          if value.is_a?(String) && value.start_with?("data:image")
            "[IMAGE_BASE64_REMOVED]"
          else
            value
          end
        end

        Llm::Response.new(
          vendor: "openai",
          model: model,
          content: response.content,
          input_tokens: response.input_tokens,
          output_tokens: response.output_tokens,
          request_payload: cleaned_body,
          response_payload: response.raw.env.response_body,
          duration_ms: ((end_time - start_time) * 1000).to_i
        )
      end
    end
  end
end
