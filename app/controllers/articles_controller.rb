class ArticlesController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :set_article, only: [:show, :update, :destroy]
  before_action :authenticate_article, only: [:update, :destroy]

  def index
    articles = Article.includes(:user).all
    format_articles = articles.map { |article| format_article_response(article) }
    render json: { articles: format_articles }, status: :ok
  end

  def create
    article = @user.articles.build(article_params)
    if article.save
      render json: { article: format_article_response(article) }, status: :created
    else
      render json: { errors: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if @article
      render json: { article: format_article_response(@article) }, status: :ok
    else
      render json: { errors: ["Article not found"] }, status: :not_found
    end
  end

  def update
    if @article.update(article_params)
      render json: { article: format_article_response(@article) }, status: :ok
    else
      render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @article.destroy
      head :no_content
    else
      render json: { errors: ["Internal server error"] }, status: :internal_server_error
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
        render json: { errors: ["Invalid token or user not found"] }, status: :unauthorized
        return
      end
    end

    def set_article
      @article = Article.find_by(slug: params[:slug])
    end

    def format_article_response(article)
      {
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
    end

    def authenticate_article
      unless @article
        render json: { errors: ["Article not found"] }, status: :not_found
        return
      end
  
      unless @user.id == @article.user_id
        render json: { errors: ["You are not authorized to perform this action"] }, status: :forbidden
        return
      end
    end

    def article_params
      params.require(:article).permit(:title, :description, :body, tag_list: [])
    end
end
