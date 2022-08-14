class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :omniauth

  def omniauth
    user = User.from_omniauth(request.env['omniauth.auth'])

    if user.valid?
      session[:user_id] = user.id
    end
    redirect_to root_path, flash: { notice: "Successfully logined" }
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, flash: { notice: "Successfully unlogined" }
  end
end
