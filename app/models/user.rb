class User < ApplicationRecord
  has_many :authorizations
  has_many :tweets
  has_many :chats

  attr_accessor :remember_token, :activation_token, :reset_token, :profile_img_data_uri, :profile_img_cache
  before_save :downcase_email
  before_create :create_activation_digest
  after_validation :set_profile_img_from_data_uri
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@(kcgrp.jp|n-currency.com|picappinc.jp|futurecomics.com|kcint.co.jp|dmm-futureworks.com|tis-s.co.jp|gotbb.co.jp|outvision.co.jp|planets.art|auto.dmm.com|digitalcommerce.co.jp|fcons.jp|futurecomics.com|hobibox.jp|lai-xiang.com|wfn-gp.com|dmm.com|mail.dmm.com|dmm.co.jp)/

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  mount_uploader :profile_img, PictureUploader
  
  validates :name, presence: true, length: { maximum:50 }
  validates :email, presence: true, length: { maximum: 255 },format: { with: VALID_EMAIL_REGEX },uniqueness:{case_sensitive: false}
  validates :self_intro, length: { maximum: 25 }
  validates :department_name, presence: true

  with_options on: :fb_login do |fb_login|
    fb_login.validates :password, presence: false
    fb_login.validates :password_confirmation, presence: false
    fb_login.validates :department_name, presence: false
    fb_login.validates :profile_img,  presence: false
  end

  validate :picture_size

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
    reset_sent_at <= 24.hours.ago
  end

  # マッチングメンバーがチャットを投稿したことを通知するメールを送信
  def self.chat_notification_email(email_lists)
    # メール一斉位送信
    UserMailer.chat_notification(email_lists).deliver_now
  end

  def set_profile_img_from_data_uri
    if profile_img_data_uri.present?
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
    @user.save(context: :fb_login)
  end

  def admin?
    self.admin
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
        errors.add(:profile_img, "ファイルは5MBより大きいサイズのファイルはアップロードできません。")
      end
    end

end