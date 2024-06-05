defmodule Blog.MyBlog.Article do
  use Ecto.Schema
  use Blog.MyBlog.Visible
  import Ecto.Changeset
  alias Blog.MyBlog.Comment

  schema "articles" do
    field :title, :string
    field :body, :string
    field :status, :string
    has_many :comments, Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body, :status])
    |> validate_required([:title, :body])
    |> validate_length(:body, min: 10)
    |> validate_inclusion(:status, ["public", "private", "archived"])
  end
end
