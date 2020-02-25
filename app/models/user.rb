class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :omniauthable,
        omniauth_providers: %i[facebook google_oauth2]

  has_many :items
  has_many :purchases
  has_many :buyings, through: :purchases, source: :item
  has_many :cards
  has_one  :private_information

  validates :nickname,
  presence: true,
  length: { maximum: 19 }
  # validates :image,
  #   presence: true
  validates :email,
  presence: true,
  uniqueness: { message: "メールアドレスに誤りがあります。ご確認いただき、正しく変更してください。" },
  format: { with: /\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*[a-zA-Z]+\z/, allow_blank: true, message: "フォーマットが不適切です" }

  validates :password,
  presence: true,
  confirmation: { message: "パスワードとパスワード（確認）が一致しません" },
  length: { in: 6..128, message: "パスワードは6文字以上128文字以下で入力してください" },
  format: { with: /\A(?=.*[^\d])+/, allow_blank: true, message: "数字のみのパスワードは設定できません" },
  on: :create

  validates :password_confirmation, presence: true,  on: :create

  validates :family_name,   presence: true
  validates :first_name,    presence: true
  validates :family_kana,   presence: true
  validates :first_kana,    presence: true
  validates :birthday,      presence: true
  validates :postal_code,   presence: true
  validates :prefectures,   presence: true
  validates :city,          presence: true
  validates :house_number,  presence: true
  validates :phone_number,  presence: true, on: :sms

  enum prefectures: {
    北海道:1,青森県:2,岩手県:3,宮城県:4,秋田県:5,山形県:6,福島県:7,
    茨城県:8,栃木県:9,群馬県:10,埼玉県:11,千葉県:12,東京都:13,神奈川県:14,
    新潟県:15,富山県:16,石川県:17,福井県:18,山梨県:19,長野県:20,
    岐阜県:21,静岡県:22,愛知県:23,三重県:24,
    滋賀県:25,京都府:26,大阪府:27,兵庫県:28,奈良県:29,和歌山県:30,
    鳥取県:31,島根県:32,岡山県:33,広島県:34,山口県:35,
    徳島県:36,香川県:37,愛媛県:38,高知県:39,
    福岡県:40,佐賀県:41,長崎県:42,熊本県:43,大分県:44,宮崎県:45,鹿児島県:46,沖縄県:47
  }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.nickname = auth.info.name
    end
  end
end