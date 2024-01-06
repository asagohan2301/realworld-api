class ArticlesController < ApplicationController
  before_action :authenticate_user

  def create
    article = @user.articles.build(article_params)
    if article.save
      data = {
        article: {
          id: article.id,
          title: article.title,
          description: article.description,
          body: article.body,
          tag_list: article.tag_list,
          created_at: article.created_at,
          updated_at: article.updated_at,
          author: @user.username
        }
      }
      render json: data, status: :created
    else
      render json: { error: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def authenticate_user
      begin
        secret = "test_secret_key"
        token = request.headers['Authorization'].split(" ").last
        decoded_token = JWT.decode token, secret, true, { algorithm: 'HS256' }
        id_hash = decoded_token.find { |h| h.key?("id") }
        @user = User.find(id_hash["id"])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        render json: { error: "Invalid token or user not found." }, status: :unauthorized
        return
      end
    end

    def article_params
      params.require(:article).permit(:title, :description, :body, tag_list: [])
    end
end
