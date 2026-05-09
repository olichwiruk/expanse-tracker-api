# frozen_string_literal: true

require "dry/monads"

module Receipts
  class CreateService
    extend Dry::Monads[:result]

    def self.call(params)
      receipt = Receipt.new(params)

      if receipt.save
        Receipts::AnalyzeJob.perform_later(receipt.id)
        Success(receipt)
      else
        Failure(receipt)
      end
    end
  end
end
