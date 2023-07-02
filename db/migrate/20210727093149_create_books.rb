class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      #t.データ型名 :カラム名
      t.string :title     #本のタイトル
      t.text :body        #画像の説明
      t.integer :user_id  #投稿したユーザを識別する ID（users テーブルの id を保存する）
      t.timestamps
    end
  end
end
