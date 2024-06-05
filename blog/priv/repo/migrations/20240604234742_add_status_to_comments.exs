defmodule Blog.Repo.Migrations.AddStatusToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
        add :status, :text, default: "public"
    end
  end
end
