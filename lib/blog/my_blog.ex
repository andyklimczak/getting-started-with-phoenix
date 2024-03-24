defmodule Blog.MyBlog do
  import Ecto.Query, warn: false

  alias Blog.Repo
  alias Blog.MyBlog.Article

  def list_articles() do
    Repo.all(Article)
  end

  def get_article!(id) do
    Repo.get!(Article, id)
  end

  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def create_article(attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
  end
end
