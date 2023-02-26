defmodule Points.Plan.Ticket do
  @moduledoc """
  Represents a unit of work
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Points.Plan.Project

  schema "tickets" do
    field :title, :string
    field :description, :string
    field :extra_info, :string
    field :position, :integer

    belongs_to :project, Project

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title, :description, :extra_info])
    |> validate_required([:title])
    |> unsafe_validate_unique([:title, :project_id], Points.Repo)
    |> unique_constraint([:title, :project_id])
    |> cast_project(attrs)
  end

  def cast_project(changeset, %{"project" => project}),
    do: put_assoc(changeset, :project, project)

  def cast_project(changeset, %{project: project}),
    do: put_assoc(changeset, :project, project)

  def cast_project(changeset, _),
    do: changeset

  def change_position(changeset, position),
    do: put_change(changeset, :position, position)
end
