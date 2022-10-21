Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://cdn.jsdelivr.net', 'https://*.tile.openstreetmap.org'
    resource '*', methods: :any, headers: :any
  end
end
