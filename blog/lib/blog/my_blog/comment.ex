defmodule Blog.MyBlog.Comment do
  use Ecto.Schema
  use Blog.MyBlog.Visible
  import Ecto.Changeset
  alias Blog.MyBlog.Article

  schema "comments" do
    field :body, :string
    field :commenter, :string
    field :status, :string
    belongs_to :article, Article

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:commenter, :body, :article_id, :status])
    |> validate_required([:commenter, :body, :article_id])
    |> validate_inclusion(:status, ["public", "private", "archived"])
  end
end
