# frozen_string_literal: true

class RemoveNameAndAddPhotoBase64ToReceipts < ActiveRecord::Migration[7.2]
  def change
    remove_column :receipts, :name, :string
    add_column :receipts, :photo_base64, :text
  end
end
