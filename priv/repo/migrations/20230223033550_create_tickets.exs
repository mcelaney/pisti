defmodule Points.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :title, :citext
      add :description, :text
      add :extra_info, :text
      add :position, :integer
      add :project_id, references(:projects, on_delete: :delete_all)

      timestamps()
    end

    create index(:tickets, [:project_id])
    create unique_index(:tickets, [:title, :project_id])
  end
end
