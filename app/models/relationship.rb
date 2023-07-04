class Relationship < ApplicationRecord
  # followerという名前の関連付けを持ち、それがUserモデルと紐付いていることを示している。
  # class_name: "User"は、関連付ける対象のモデルがUserモデルであることを指定している。
  belongs_to :follower, class_name: "User"
  # Relationshipモデルがfollowedという名前の関連付けを持ち、Userモデルと紐付いていることを示している。
  belongs_to :followed, class_name: "User"
end
