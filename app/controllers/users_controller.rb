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

  private
  
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
end
