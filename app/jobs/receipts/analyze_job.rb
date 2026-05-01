# frozen_string_literal: true

module Receipts
  class AnalyzeJob < ApplicationJob
    queue_as :default

    def perform(receipt_id)
      receipt = ::Receipt.find(receipt_id)
      service = Receipts::AnalyzeService.new(
        llm_adapter: Llm::Adapters::OpenAi.new
      )
      service.call(receipt)
    end
  end
end
