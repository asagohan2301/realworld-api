class ArticlesController < ApplicationController
  def create
    secret = "test_secret_key"
    token = request.headers['Authorization'].split(" ").last
    decoded_token = JWT.decode token, secret, true, { algorithm: 'HS256' }

    id = 0
    decoded_token.each do |h|
      id = h["id"] if h.key?("id")
    end

    user = User.find(id)
    article = user.articles.build(article_params)
  
    if article.save
      data = {
        article: {
          id: article.id,
          title: article.title
        }
      }
      render json: data, status: :created
    else
      render json: { error: article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def article_params
    params.require(:article).permit(:title, :description, :body, tag_list: [])
  end
end
