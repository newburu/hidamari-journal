class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :omniauthable, omniauth_providers: [ :google_oauth2, :twitter2 ]

  has_many :annual_themes, dependent: :destroy
  has_many :monthly_goals, dependent: :destroy
  has_many :daily_tasks, dependent: :destroy
  has_many :reflections, dependent: :destroy

  def self.from_omniauth(auth)
    Rails.logger.info "OMNIAUTH DEBUG: Auth Payload: #{auth.inspect}"

    # Check for existing user by provider and uid
    user = find_by(provider: auth.provider, uid: auth.uid)
    if user
      Rails.logger.info "OMNIAUTH DEBUG: Updating existing user #{user.id} with name: #{auth.info.name}"
      user.update(name: auth.info.name)
      return user
    end

    # Check for existing user by email (if email is provided)
    email = auth.info.email
    if email
      user = find_by(email: email)
      if user
        Rails.logger.info "OMNIAUTH DEBUG: Linking existing user #{user.id} by email"
        user.update(provider: auth.provider, uid: auth.uid, name: auth.info.name)
        return user
      end
    end

    # Build a new user
    Rails.logger.info "OMNIAUTH DEBUG: Creating new user"
    new_user = new
    new_user.provider = auth.provider
    new_user.uid = auth.uid
    new_user.email = email || "#{auth.uid}-#{auth.provider}@example.com"
    new_user.name = auth.info.name
    new_user.password = Devise.friendly_token[0, 20]

    # Save the user to ensure persistence
    if new_user.save
      Rails.logger.info "OMNIAUTH DEBUG: Created user #{new_user.id}"
      new_user
    else
      Rails.logger.error "OMNIAUTH DEBUG: Failed to create user: #{new_user.errors.full_messages}"
      new_user # Return unsaved user so controller can show errors
    end
  end
end
