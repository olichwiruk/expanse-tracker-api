# frozen_string_literal: true

module Receipts
  class AnalyzeService
    class << self
      def call(receipt)
        receipt.processing!

        llm_adapter = Llm::Adapters::OpenAi.new
        llm_response = llm_adapter.extract_structured_data(image: receipt.photo)

        record_attempt!(receipt, llm_response)

        extracted_data = Receipts::ExtractedData.new(llm_response.content)

        receipt.llm_payload = extracted_data.to_h
        receipt.status = :success
        receipt.save!
      end

      private def record_attempt!(receipt, response)
        receipt.llm_attempts.create!(
          vendor: response.vendor,
          llm_model_name: response.model,
          status: "success",
          request_payload: response.request_payload,
          response_payload: response.response_payload,
          input_tokens: response.input_tokens,
          output_tokens: response.output_tokens,
          duration_ms: response.duration_ms
        )
      end
    end
  end
end
