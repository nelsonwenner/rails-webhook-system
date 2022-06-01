# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhookEvent, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:webhook_endpoint) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:event) }
    it { is_expected.to validate_presence_of(:payload) }
  end
end
