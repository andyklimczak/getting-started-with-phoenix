defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  alias Blog.MyBlog
  alias Blog.MyBlog.Article

  def index(conn, _params) do
    articles = MyBlog.list_articles()
    render(conn, :index, articles: articles)
  end

  def show(conn, %{"id" => id}) do
    article = MyBlog.get_article!(id)
    render(conn, :show, article: article)
  end

  def new(conn, _params) do
    changeset = MyBlog.change_article(%Article{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    case MyBlog.create_article(article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: ~p"/articles/#{article}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    article = MyBlog.get_article!(id)
    changeset = MyBlog.change_article(article)
    render(conn, :edit, article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = MyBlog.get_article!(id)

    case MyBlog.update_article(article, article_params) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: ~p"/articles/#{article}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = MyBlog.get_article!(id)
    {:ok, _article} = MyBlog.delete_article(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> put_status(:see_other)
    |> redirect(to: ~p"/")
  end
end
