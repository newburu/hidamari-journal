class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :annual_themes, dependent: :destroy
  has_many :monthly_goals, dependent: :destroy
  has_many :daily_tasks, dependent: :destroy
  has_many :reflections, dependent: :destroy
end
