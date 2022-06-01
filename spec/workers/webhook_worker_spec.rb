require 'rails_helper'

RSpec.describe WebhookWorker, type: :worker do
  let(:subject) { described_class.new(event_id: webhook_event.id) }

  let(:webhook_event) { create(:webhook_event) }

  let(:response) do
    double(
      headers: {
        content_type: 'application/json'
      },
      body: 'success',
      code: 200,
      status: double(success?: true)
    )
  end

  describe '#call' do
    context 'when is valid' do
      it 'update webhook event response with success status' do
        subject.stub(:fetch_response) { response }

        expect {
          subject.call
        }.to change {
          webhook_event.reload.response
        }.from({}).to({ "body" => "success", "code" => 200,
                        "headers" => { "content_type" => "application/json" } })
      end
    end

    context 'when is not valid' do
      let(:failed_request_error) { described_class::FailedRequestError }
      let(:http_timeout_error) { HTTP::TimeoutError }
      let(:http_connection_error) { HTTP::ConnectionError }

      let(:response) do
        double(
          headers: {
            content_type: 'application/json'
          },
          body: 'failure',
          code: 400,
          status: double(success?: false)
        )
      end

      it 'raise failed request error' do
        subject.stub(:fetch_response) { response }

        expect { subject.call }.to raise_error(failed_request_error)
      end

      it 'update webhook event response with timeout error' do
        subject.stub(:fetch_response) { raise http_timeout_error }

        expect {
          subject.call
        }.to change {
          webhook_event.reload.response
        }.from({}).to({ "error" => "TIMEOUT_ERROR" })
      end

      it 'update webhook event response with connection error' do
        subject.stub(:fetch_response) { raise http_connection_error }

        expect {
          subject.call
        }.to change {
          webhook_event.reload.response
        }.from({}).to({ "error" => "CONNECTION_ERROR" })
      end
    end
  end
end
