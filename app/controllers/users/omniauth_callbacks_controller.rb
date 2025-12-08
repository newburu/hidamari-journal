class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth("google")
  end

  def twitter2
    handle_auth("twitter")
  end

  def failure
    redirect_to root_path
  end

  private

  def handle_auth(kind)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: kind.capitalize
      sign_in_and_redirect @user, event: :authentication
    elsif @user.email.present? && @user.save
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: kind.capitalize
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.omniauth_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end
end
