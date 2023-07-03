class BooksController < ApplicationController
  def new
    # Viewへ渡すためのインスタンス変数に空のModelオブジェクトを生成する。
    @book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    @books =Book.new
    @user=@book.user
    @book_comment = BookComment.new # コメント機能用
  end

  def index
    @books = Book.all
    @book =Book.new
  end

  # 作成データの保存
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id

    # バリデーション設定
    if @book.save
      # 新規投稿が成功したとき:フラッシュメッセージ
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book.id)
    else
      @books = Book.all
      render :index
    end
  end

  def edit
    # アクセスを制限設定（private以降の行に内容を設定）
    is_matching_login_user
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])    # Bookの取得

    # バリデーション設定
    if @book.update(book_params)      # Bookのアップデート
      # 投稿の更新が成功したとき:フラッシュメッセージ
      flash[:notice] = "You have updated book successfully."
       redirect_to book_path(@book.id)   # Bookの詳細ページへのパス
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body )
  end

  def is_matching_login_user
    book= Book.find(params[:id])
    user= book.user
    unless user.id == current_user.id
      redirect_to books_path
    end
  end

end
