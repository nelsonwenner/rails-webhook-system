# frozen_string_literal: true

class WebhookEvent < ApplicationRecord
  belongs_to :webhook_endpoint

  validates :event, presence: true
  validates :payload, presence: true
end
