defmodule Points.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :title, :citext
      add :status, :string
      add :position, :integer
      add :parent_id, references(:projects, on_delete: :delete_all), null: true

      timestamps()
    end

    create index(:projects, [:parent_id])
    create unique_index(:projects, [:title, :parent_id])
  end
end
