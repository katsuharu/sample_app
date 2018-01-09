Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'],
	scope: 'email,user_birthday,user_likes, user_friends, public_profile', display: 'popup',
	client_options: {
	site: 'https://graph.facebook.com/v2.11',
	authorize_url: "https://www.facebook.com/v2.11/dialog/oauth"
	},
	local: "ja_JP",
	info_fields: "email, favorite_teams, user_birthday, favorite_athletes, gender, first_name, last_name"
end