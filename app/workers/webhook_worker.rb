# frozen_string_literal: true

require "http"

class WebhookWorker < ApplicationWorker
  class FailedRequestError < StandardError; end

  def initialize(event_id:)
    @event_id = event_id
  end

  def call
    return if webhook_event.blank? || webhook_endpoint.blank?

    webhook_event.update(response: {
                           headers: fetch_response.headers.to_h,
                           code: fetch_response.code.to_i,
                           body: fetch_response.body.to_s
                         })

    raise FailedRequestError unless fetch_response.status.success?
  rescue HTTP::TimeoutError
    webhook_event.update(response: { error: "TIMEOUT_ERROR" })
  rescue HTTP::ConnectionError
    webhook_event.update(response: { error: "CONNECTION_ERROR" })
  end

  private

    def fetch_response
      # Request with a 30 second timeout.
      @fetch_response ||= HTTP.timeout(30).headers(
        "User-Agent": "webhook_system/1.0",
        "Content-Type": "application/json"
      ).post(webhook_endpoint.url,
             body: {
               event: webhook_event.event,
               payload: webhook_event.payload
             }.to_json)
    end

    def webhook_event
      @webhook_event ||= WebhookEvent.find_by(id: @event_id)
    end

    def webhook_endpoint
      @webhook_endpoint ||= webhook_event&.webhook_endpoint
    end
end
