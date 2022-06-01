# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEndpoint, type: :model do
  describe 'Associations' do
    it { is_expected.to have_many(:webhook_events).dependent(:destroy) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:url) }
  end
end
