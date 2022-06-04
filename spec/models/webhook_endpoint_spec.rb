# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEndpoint, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:webhook_events).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:url) }
  end

  describe '#subscribed?' do
    let!(:webhook_endpoint) { create(:webhook_endpoint, subscriptions: [event]) }
    let(:event) { 'events.test' }

    context 'when event is present in the subscriptions' do
      specify do
        expect(webhook_endpoint.subscribed?(event: event)).to eq(true)
      end 
    end

    context "when don't event is present in the subscriptions" do
      let(:event_test) { 'events.noop' }

      specify do
        expect(webhook_endpoint.subscribed?(event: event_test)).to eq(false)
      end 
    end
  end
end
