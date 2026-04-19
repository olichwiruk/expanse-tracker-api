class ReceiptsController < ApplicationController
  def upload
    errors = validate_upload_params

    if errors.empty?
      render json: { success: true }, status: :accepted
    else
      render json: { errors: errors }, status: :bad_request
    end
  end

  private def validate_upload_params
    errors = []
    name = params[:name]

    errors << "Name is missing" if name.blank?
    errors << "Name must be a string" unless name.is_a? String
    errors << "Name is too short" if name.to_s.length < 3
    errors << "Name is too long" if name.to_s.length > 39

    errors
  end
end
