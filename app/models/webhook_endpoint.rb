# frozen_string_literal: true

class WebhookEndpoint < ApplicationRecord
  has_many :webhook_events, dependent: :destroy

  validates :url, presence: true
end
