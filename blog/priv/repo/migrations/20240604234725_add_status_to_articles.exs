defmodule Blog.Repo.Migrations.AddStatusToArticles do
  use Ecto.Migration

  def change do
    alter table(:articles) do
        add :status, :text, default: "public"
    end
  end
end
