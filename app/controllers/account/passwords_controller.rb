class Account::PasswordsController < ApplicationController
  before_action :authenticate_user!
  before_action :configure_minimum_password_length, only: [:edit]

  def show
    redirect_to edit_account_password_path
  end

  def edit
  end

  def update
    if current_user.update_with_password(password_params)
      bypass_sign_in current_user
      redirect_to account_password_path, notice: "パスワードの保存に成功しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end

  def configure_minimum_password_length
    @minimum_password_length = Devise.password_length.min
  end
end
