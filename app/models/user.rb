class User < ApplicationRecord
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]

  attr_writer :login

  def generate_new_authentication_token
    token = User.generate_unique_secure_token
    update authentication_token: token
  end

  def login
    @login || self.email || self.username
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
      if (login = conditions.delete(:login))
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
  end

end