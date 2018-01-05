class User < ApplicationRecord
	has_many :authorizations
	
	attr_accessor :remember_token, :activation_token, :reset_token, :profile_img_data_uri, :profile_img_cache
	before_save :downcase_email
	before_create :create_activation_digest
	before_validation :set_profile_img_from_data_uri
	validates :name, presence: true, length: { maximum:50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX },
	uniqueness:{case_sensitive: false}
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }
	mount_uploader :profile_img, PictureUploader
	# validates :profile_img, 	presence: true
	# validates :profile_img_data_uri, presence: true
	validates :self_intro, length: { maximum: 25 }
	validates :department_name, presence: true ,on: :create
	validates :slack_id, presence: true ,on: :create
	validate :picture_size

	validates :password, presence: false, on: :facebook_login
	validates :password_confirmation, presence: false, on: :facebook_login
	validates :department_name, presence: false, on: :facebook_login
	validates :slack_id, presence: false, on: :facebook_login


	include UsersHelper

	# 渡された文字列のハッシュ値を返す
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
		                                              BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# ランダムなトークンを返す
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	#永続セッションのためにユーザーをDBに記憶する
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	#渡されたトークンがダイジェストと一致したらtrueを返す
	def authenticated?(attribute,token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	# アカウントを有効にする
	def activate
		update_attribute(:activated,    true)
		update_attribute(:activated_at, Time.zone.now)
	end

	# 有効化用のメールを送信する
	def send_activation_email
		UserMailer.account_activation(self).deliver_now
	end

	# パスワード再設定の属性を設定する
	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest,  User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	# パスワード再設定のメールを送信する
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	# パスワード再設定の期限が切れている場合はtrueを返す
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end

	#マッチングが成功したことを知らせるメールを送信
	def send_success_email
		UserMailer.matching_success(self).deliver_now
	end

	#マッチング失敗したことを知らせるメールを送信
	def send_fail_email
		UserMailer.matching_fail(self).deliver_now
	end

	def set_profile_img_from_data_uri
		if profile_img_data_uri
	    	self.profile_img = data_uri_to_file(profile_img_data_uri)
		end
	end

	def User.create_from_auth!(auth)
		@user = User.new(
	    	name: auth.info.name,
	    	email: auth.info.email,
	    	password: "sasaki",
	    	profile_img: auth.info.image,
			activated: true,
			activated_at: Time.zone.now
		)
		@user.save(context: :facebook_login)
	    @user
	end


	private

		# メールアドレスをすべて小文字にする
		def downcase_email
	   		self.email = email.downcase
	   	end

	   	# 有効化トークンとダイジェストを作成および代入する
	   	def create_activation_digest
	    	self.activation_token  = User.new_token
	    	self.activation_digest = User.digest(activation_token)
	   	end


	    # アップロードされた画像のサイズをバリデーションする
		def picture_size
			if profile_img.size > 5.megabytes
				errors.add("ファイルは5MBより大きいサイズのファイルはアップロードできません。")
			end
		end
end