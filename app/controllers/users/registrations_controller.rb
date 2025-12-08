class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super do |resource|
      if (omniauth_data = session["devise.omniauth_data"])
        resource.email = omniauth_data["info"]["email"]
      end
    end
  end

  protected

  def build_resource(hash = {})
    super(hash)
    if (omniauth_data = session["devise.omniauth_data"])
      resource.provider = omniauth_data["provider"]
      resource.uid = omniauth_data["uid"]
    end
  end
end
