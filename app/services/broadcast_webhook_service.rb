class BroadcastWebhookService < ApplicationService
  def initialize(event:, payload:)
    @event = event
    @payload = payload
  end

  def call
    WebhookEndpoint.find_each do |webhook_endpoint|
      # Skip over endpoints that are not subscribed 
      # to the current event being broadcast.
      next unless webhook_endpoint.subscribed?(event: event)

      webhook_event = WebhookEvent.create!(
        webhook_endpoint: webhook_endpoint,
        event: event,
        payload: payload
      )

      WebhookWorker.perform_async(webhook_event.id)
    end
  end

  private

    attr_reader :event, :payload
end
