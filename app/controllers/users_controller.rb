class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      data = {
        user: {
          username: user.username,
          email: user.email
        }
      }
      render json: data, status: :created
    else
      error = {
        messages: user.errors.full_messages
      }
      render json: error, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: login_params[:email])
    if user && user.authenticate(login_params[:password])
      payload = { id: user.id }
      secret = "test_secret_key"
      token = JWT.encode payload, secret, "HS256"
      data = {
        user: {
          username: user.username,
          token: token
        }
      }
      render json: data, status: :ok
    else
      render json: { error: "Authentication failed." }, status: :unauthorized
    end
  end

  private
  
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

    def login_params
      params.require(:user).permit(:email, :password)
    end
end
