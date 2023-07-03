class Favorite < ApplicationRecord
  # Favoriteモデルのカラム（book_idとuser_id）は、Bookモデル、Userモデルのidと関連付ける。
  belongs_to :user
  belongs_to :book
end
