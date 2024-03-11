defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  alias Blog.Repo
  alias Blog.MyBlog.Article

  def index(conn, _params) do
    articles = Repo.all(Article)
    render(conn, :index, articles: articles)
  end
end
