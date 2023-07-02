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

  # User モデルに対して、Book モデルが 1:N になるよう関連付け
  # booksという名前でActiveStorageでプロフィール画像を保存できるように設定
  has_one_attached :profile_image

  # validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    # メソッドに対して引数を設定し、引数に設定した値に画像のサイズを変換するように設定
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end
