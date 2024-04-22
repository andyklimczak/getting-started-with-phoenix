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

  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
  end

  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end
end
