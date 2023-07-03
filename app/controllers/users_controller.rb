class UsersController < ApplicationController
  #before_action :ensure_correct_user, only: [:update]

  def show
    #データ（レコード）を1件取得
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @user= current_user
    @users = User.all
    @book = Book.new
  end

  def edit
    # アクセスを制限設定（private以降の行に内容を設定）
    is_matching_login_user
    @user = User.find(params[:id])
  end

  def update
    # バリデーション設定
    @user = User.find(params[:id])
    if @user.update(user_params)    # ユーザーのアップデート
      # ユーザのプロフィール更新が成功したとき:フラッシュメッセージ
      redirect_to user_path(current_user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  # 作成データのストロングパラメータ
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  # 他のユーザーからのアクセスを制限設定
  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end

end
