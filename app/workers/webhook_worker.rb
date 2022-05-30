# frozen_string_literal: true

require 'http'

class WebhookWorker < ApplicationWorker
  class FailedRequestError < StandardError; end

  def initialize(event_id:)
    @event_id = event_id
  end

  def perform
    return if webhook_event.blank? || webhook_endpoint.blank?

    # Send the webhook request with a 30 second timeout.
    response = HTTP.timeout(30)
      .headers(
        'User-Agent': 'webhook_system/1.0',
        'Content-Type': 'application/json'
      )
      .post(
        webhook_endpoint.url,
        body: {
          event: webhook_event.event,
          payload: webhook_event.payload
        }.to_json
      )

    # Store the webhook response
    webhook_event.update(response: {
                           headers: response.headers.to_h,
                           code: response.code.to_i,
                           body: response.body.to_s
                         })

    raise FailedRequestError unless response.status.success?
  rescue HTTP::TimeoutError
    webhook_event.update(response: { error: 'TIMEOUT_ERROR' })
  rescue HTTP::ConnectionError
    webhook_event.update(response: { error: 'CONNECTION_ERROR' })
  end

  private

    attr_reader :webhook_event, :webhook_endpoint

    def webhook_event
      @webhook_event ||= WebhookEvent.find_by(id: @event_id)
    end

    def webhook_endpoint
      @webhook_endpoint ||= webhook_event.webhook_endpoint
    end
end
