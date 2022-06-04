# frozen_string_literal: true

class WebhookEndpoint < ApplicationRecord
  has_many :webhook_events, dependent: :destroy

  validates :subscriptions, length: { minimum: 1 }, presence: true
  validates :url, presence: true

  scope :enabled, -> { where(enabled: true) } 

  def subscribed?(event:)
    (subscriptions & ['*', event]).any?
  end

  def disable!
    update!(enabled: false)
  end 
end
