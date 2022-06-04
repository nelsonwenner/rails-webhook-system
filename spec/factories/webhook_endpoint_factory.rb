FactoryBot.define do
  factory :webhook_endpoint do
    url { 'http://example.com/foo?bar=baz' }
    subscriptions { ['events.test'] }
  end
end
