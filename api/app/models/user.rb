class User < ApplicationRecord
  # TODO cut this down - seehttps://github.com/heartcombo/devise?tab=readme-ov-file#:~:text=It%27s%20composed%20of%2010%20modules
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    # NOTE this stops jwt revocation - not production ready! consider JTIMatcher?
    :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

end
