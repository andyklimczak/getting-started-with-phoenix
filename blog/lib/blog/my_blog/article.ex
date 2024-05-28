defmodule Blog.MyBlog.Article do
  use Ecto.Schema
  import Ecto.Changeset
  alias Blog.MyBlog.Comment

  schema "articles" do
    field :title, :string
    field :body, :string
    has_many :comments, Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> validate_length(:body, min: 10)
  end
end
