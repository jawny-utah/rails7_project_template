Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitch, ENV["twitch_client_id"], ENV["twitch_client_secret"]
end
