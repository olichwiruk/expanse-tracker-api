# frozen_string_literal: true

class CreateLlmAttempts < ActiveRecord::Migration[7.2]
  def change
    create_table :llm_attempts do |t|
      t.references :receipt, null: false, foreign_key: true
      t.string :vendor
      t.string :llm_model_name
      t.string :status
      t.jsonb :request_payload, null: false, default: {}
      t.jsonb :response_payload, null: false, default: {}
      t.text :error_message
      t.integer :duration_ms
      t.integer :input_tokens
      t.integer :output_tokens

      t.timestamps
    end

    add_index :llm_attempts, :request_payload, using: :gin
    add_index :llm_attempts, :response_payload, using: :gin
  end
end
