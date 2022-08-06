class User < ApplicationRecord
  def self.from_omniauth(res)
    User.find_or_create_by(uid: res[:uid]) do |user|
      user.name = res[:info][:name] || res[:info][:nickname]
      user.avatar = res[:info][:image]
    end
  end
end
