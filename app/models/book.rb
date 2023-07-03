class Book < ApplicationRecord
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  has_many :favorites, dependent: :destroy      # いいね機能
  has_many :book_comment, dependent: :destroy   # コメント機能

  # 引数で渡されたユーザidがFavoritesテーブル内に存在（exists?）するかどうかを調べます。
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
