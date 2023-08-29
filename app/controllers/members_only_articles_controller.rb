class MembersOnlyArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_user, only: [:index, :show]
  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    if article.is_member_only
      render json: article
    else
      render json: {error: "Unauthorized - You need to sign in"}, status: :unauthorized
    end
  end
  private
  def authenticate_user
    unless session[:user_id]
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
