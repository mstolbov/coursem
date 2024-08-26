Rails.application.config.generators do |g|
  g.test_framework :rspec, fixture: true, fixture_replacement: :factory_bot
  g.assets = false
  g.helper = false
end