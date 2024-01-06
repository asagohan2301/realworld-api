class ArticlesController < ApplicationController
  before_action :authenticate_user

  def create
    article = @user.articles.build(article_params)
    if article.save
      data = {
        article: {
          slug: article.slug,
          title: article.title,
          description: article.description,
          body: article.body,
          tag_list: article.tag_list,
          created_at: article.created_at,
          updated_at: article.updated_at,
          author: {
            username: @user.username
          }
        }
      }
      render json: data, status: :created
    else
      render json: { error: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    article = Article.find_by(slug: params[:slug])
    if article
      data = {
        article: {
          slug: article.slug,
          title: article.title,
          description: article.description,
          body: article.body,
          tag_list: article.tag_list,
          created_at: article.created_at,
          updated_at: article.updated_at,
          author: {
            username: article.user.username
          }
        }
      }
      render json: data, status: :ok
    else
      render json: { error: "Article not found." }, status: :not_found
    end
  end

  def update
    article = Article.find_by(slug: params[:slug])

    unless article
      render json: { error: "Article not found." }, status: :not_found
      return
    end

    unless @user.id == article.user_id
      render json: { error: "You are not authorized to perform this action." }, status: :forbidden
      return
    end
    
    if article.update(article_params)
      data = {
        article: {
          slug: article.slug,
          title: article.title,
          description: article.description,
          body: article.body,
          tag_list: article.tag_list,
          created_at: article.created_at,
          updated_at: article.updated_at,
          author: {
            username: article.user.username
          }
        }
      }
      render json: data, status: :ok
    else
      render json: { error: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    article = Article.find_by(slug: params[:slug])

    unless article
      render json: { error: "Article not found." }, status: :not_found
      return
    end

    unless @user.id == article.user_id
      render json: { error: "You are not authorized to perform this action." }, status: :forbidden
      return
    end

    if article.destroy
      head :no_content
    else
      render json: { error: "Internal server error." }, status: :internal_server_error
    end
  end

  private

    def authenticate_user
      begin
        secret = Rails.application.credentials.jwt_secret_key
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
