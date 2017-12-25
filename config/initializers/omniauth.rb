Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Rails.application.secrets[:facebook][:key], Rails.application.secrets[:facebook][:secret]
end