class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid, :access_token

  class << self
    # Reference: https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
    def find_or_create_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      if user
        user.update_attributes(access_token: auth.credentials.token)
      else
        user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           access_token: auth.credentials.token)
      end

      user
    end
  end

  def as_json(options)
    userHash = super(options.merge({
      only: [:id, :name, :email, :provider, :uid]
    }))

    userHash.merge(roles: roles.map(&:name))
  end
end

