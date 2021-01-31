class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :set_search_posts_form

  protected

  def not_authenticated
    redirect_to root_url
  end

  def set_search_posts_form
    @search_form = SearchForm.new(search_params)
  end

  def search_params
    params.fetch(:search, {}).permit(:post_content, :comment_content, :name)
  end
end
