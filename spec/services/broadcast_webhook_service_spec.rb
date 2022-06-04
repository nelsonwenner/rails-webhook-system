require 'rails_helper'

RSpec.describe BroadcastWebhookService, type: :service do
  subject { described_class.new(event: event, payload: payload) }

  let!(:webhook_endpoint) { create(:webhook_endpoint) }
  let(:event) { 'events.test' }
  let(:payload) { { 'test': 1 } }

  describe '.call' do
    context 'when is valid' do
      it 'check if the event are subscribed' do
        expect(WebhookWorker).to receive(:perform_async).once

        subject.call
      end

      it 'create the webhook event' do
        expect { 
          subject.call
        }.to change(WebhookEvent, :count).by(1)
      end

      context 'with worker' do
        it 'check amount of jobs executed' do
          expect {
            subject.call
          }.to change { WebhookWorker.jobs.size }.by(1)
        end
      end
    end

    context 'when is not valid' do
      let(:event) { 'events.noop' }

      it 'check if the event is not subscribed' do
        expect(WebhookWorker).to_not receive(:perform_async)

        subject.call
      end

      it 'create the webhook event' do
        expect { 
          subject.call
        }.to change(WebhookEvent, :count).by(0)
      end

      context 'with worker' do
        it 'check amount of jobs executed' do
          expect {
            subject.call
          }.to change { WebhookWorker.jobs.size }.by(0)
        end
      end
    end
  end
end
