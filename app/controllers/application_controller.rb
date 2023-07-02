class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about]
  # devise利用の機能（ユーザ登録、ログイン認証など）使用前にconfigure_permitted_parametersメソッドを実行
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Sign up・Log in後にどこに遷移するかを設定しているメソッド
  def after_sign_in_path_for(resource)
    user_path(current_user)  # ユーザーの詳細画面
  end

  # サインアウト後にどこに遷移するかを設定するメソッド、Topページへ遷移
  def after_sign_out_path_for(resource)
    # ユーザログアウトが成功したとき:フラッシュメッセージ
    flash[:notice] = "Signed out successfully."
    root_path
  end

  # protectedは呼び出された他のコントローラからも参照することが可能
  protected

  # ユーザー登録(sign_up)の際に、ユーザー名(name)、emailのデータ操作を許可する設定
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end
end
