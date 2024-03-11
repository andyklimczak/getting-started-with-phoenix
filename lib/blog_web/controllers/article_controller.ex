defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
