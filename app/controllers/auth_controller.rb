class AuthController < ApplicationController
  skip_before_action :authenticate_user, only: [:login]

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user.slice(:id, :name, :role) }
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
end
