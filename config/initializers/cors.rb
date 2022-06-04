Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://cdn.jsdelivr.net'
    resource '*', methods: :any, headers: :any
  end
end
