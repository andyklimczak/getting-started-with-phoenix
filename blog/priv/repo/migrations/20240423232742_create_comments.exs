defmodule Blog.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :commenter, :string
      add :body, :text
      add :article_id, references(:articles, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:article_id])
  end
end
