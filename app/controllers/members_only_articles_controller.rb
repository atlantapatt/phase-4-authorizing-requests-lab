class MembersOnlyArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    if session[:user_id]
      articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
      render json: articles, each_serializer: ArticleListSerializer
    else
      not_authorized
    end
    
  end

  def show
    if session[:user_id]
      article = Article.find(params[:id])
      render json: article
    else
      not_authorized
    end
   
  end

  private

  def not_authorized
    render json: { error: "Not authorized" }, status: 401
  end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
