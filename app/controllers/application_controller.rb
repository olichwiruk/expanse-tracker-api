# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing do |e|
    status = :bad_request

    render json: {
      errors: [ {
        status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status].to_s,
        code: "parameter_missing",
        detail: e.message
      } ]
    }, status: status
  end

  def render_errors(errors, status)
    serialized_errors = errors.map do |error|
      {
        status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status].to_s,
        code: error.type,
        detail: error.full_message
      }
    end

    render json: { errors: serialized_errors }, status: status
  end
end
