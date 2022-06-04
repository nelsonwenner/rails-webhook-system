require 'rails_helper'

RSpec.describe WebhookWorker, type: :worker do
  subject { described_class.new }

  let!(:webhook_event) { create(:webhook_event) }

  let(:headers) { double(:headers) }
  let(:post) { double(:post) }

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

  before do
    allow(HTTP).to receive(:timeout).and_return(headers)
    allow(headers).to receive(:headers).and_return(post)
    allow(post).to receive(:post).and_return(response)
  end

  describe '#perform' do
    context 'when is valid' do
      it 'update webhook event response with success status' do
        expect {
          subject.perform(webhook_event.id)
        }.to change {
          webhook_event.reload.response
        }.from({}).to({ "body" => "success", "code" => 200,
                        "headers" => { "content_type" => "application/json" } })
      end

      it 'check if event are subscribed' do
        expect(HTTP).to receive(:timeout)

        subject.perform(webhook_event.id)
      end
    end

    context 'when is not valid' do
      let(:failed_request_error) { described_class::FailedRequestError }
      let(:http_timeout_error) { HTTP::TimeoutError }
      let(:http_connection_error) { HTTP::ConnectionError }

      context "check if don't event are subscribed" do
        let!(:webhook_event) { create(:webhook_event, event: 'events.noop') }

        specify do
          expect(HTTP).to_not receive(:timeout)

          subject.perform(webhook_event.id)
        end
      end

      context 'with raise failed request error' do
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

        specify do
          expect { subject.perform(webhook_event.id) }.to raise_error(failed_request_error)
        end
      end

      context 'with update webhook event response with timeout error' do
        before do
          allow(post).to receive(:post).and_raise(http_timeout_error)
        end

        specify do
          expect {
            subject.perform(webhook_event.id)
          }.to change {
            webhook_event.reload.response
          }.from({}).to({ "error" => "TIMEOUT_ERROR" })
        end
      end

      context 'with update webhook event response with connection error' do
        before do
          allow(post).to receive(:post).and_raise(http_connection_error)
        end

        specify do
          expect {
            subject.perform(webhook_event.id)
          }.to change {
            webhook_event.reload.response
          }.from({}).to({ "error" => "CONNECTION_ERROR" })
        end
      end
    end
  end
end
