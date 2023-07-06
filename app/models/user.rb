class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーションを設定
  validates :name, uniqueness: true                 # 一意性を持たせる
  validates :name, length: { in: 2..20 }            # 2～20文字の範囲
  validates :introduction, length: { maximum: 50 }  #「50字以下」

  # # dependent: :destroyは、has_manyで使えるオプションです。 1:Nの関係において、
  # 「1」のデータが削除された場合、関連する「N」のデータも削除される設定
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy      # いいね機能
  has_many :book_comment, dependent: :destroy   # コメント機能

  # User モデルに対して、Book モデルが 1:N になるよう関連付け
  # booksという名前でActiveStorageでプロフィール画像を保存できるように設定
  has_one_attached :profile_image
  # フォローしている関連付け
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # フォローされている関連付け
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # フォローしているユーザーを取得
  has_many :followings, through: :active_relationships, source: :followed
  # フォロワーを取得
  has_many :followers, through: :passive_relationships, source: :follower

  # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end

  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    # メソッドに対して引数を設定し、引数に設定した値に画像のサイズを変換するように設定
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end
end
