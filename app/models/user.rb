class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :omniauthable, omniauth_providers: [ :google_oauth2, :twitter2 ]

  has_many :annual_themes, dependent: :destroy
  has_many :monthly_goals, dependent: :destroy
  has_many :daily_tasks, dependent: :destroy
  has_many :reflections, dependent: :destroy

  def self.from_omniauth(auth)
    # Check for existing user by provider and uid
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    # Check for existing user by email
    if auth.info.email
      user = find_by(email: auth.info.email)
      if user
        # Link the account
        user.update(provider: auth.provider, uid: auth.uid)
        return user
      end
    end

    # Build a new user
    new.tap do |new_user|
      new_user.provider = auth.provider
      new_user.uid = auth.uid
      new_user.email = auth.info.email if auth.info.email
      new_user.password = Devise.friendly_token[0, 20]
    end
  end
end
