Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, "529254484110388", "71b7a37eb2fd4a1d69266fae83e9857d"
end