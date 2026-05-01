# frozen_string_literal: true

FactoryBot.define do
  factory :receipt do
    status { :pending }

    trait :with_photo do
      after(:build) do |receipt|
        receipt.photo.attach(
          io: StringIO.new('fake'),
          filename: 'fake.jpg',
          content_type: 'image/jpeg'
        )
      end
    end
  end
end
