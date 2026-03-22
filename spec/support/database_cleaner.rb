# frozen_string_literal: true

RSpec.configure do |config|
  DatabaseCleaner.clean_with(:truncation)

  config.before do
    DatabaseCleaner.strategy = :transaction
  end

  config.before do
    DatabaseCleaner.start
  end

  config.append_after do
    DatabaseCleaner.clean
  end
end
