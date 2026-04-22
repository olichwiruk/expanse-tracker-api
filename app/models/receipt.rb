# frozen_string_literal: true

class Receipt < ApplicationRecord
  enum :status, { pending: 0, processing: 1, success: 2, failed: 3 }

  validates :status, presence: true
  validates :photo_base64, presence: true, length: { maximum: 15_000_000 }
end
