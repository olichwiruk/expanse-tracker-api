# frozen_string_literal: true

require "dry/monads"

class ReceiptsController < ApplicationController
  include Dry::Monads[:result]

  def create
    result = Receipts::CreateService.call(create_params)

    case result
    in Success(receipt)
      render json: { success: true, receiptId: receipt.id }, status: :created
    in Failure(receipt)
      render_errors(receipt.errors, :unprocessable_content)
    end
  end

  private def create_params
    params.require(:photo)
    params.permit(:photo)
  end
end
