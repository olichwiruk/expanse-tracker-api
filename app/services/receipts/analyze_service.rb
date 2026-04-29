# frozen_string_literal: true

module Receipts
  class AnalyzeService
    def self.call(receipt)
      receipt.processing!

      llm_adapter = Llm::Adapters::OpenAi.new
      llm_output = llm_adapter.extract_structured_data(image: receipt.photo)

      extracted_data = Receipts::ExtractedData.new(llm_output)

      receipt.llm_payload = extracted_data.to_h
      receipt.status = :success
      receipt.save!
    end
  end
end
