class ApplicationWorker
  include Sidekiq::Worker

  def self.call(...)
    new(...).call
  end
end
