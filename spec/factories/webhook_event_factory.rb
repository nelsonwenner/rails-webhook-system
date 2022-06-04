# frozen_string_literal: true

FactoryBot.define do
  factory :webhook_event do
    event { 'events.test' }
    payload { { test: 1 } }
    webhook_endpoint
  end
end
