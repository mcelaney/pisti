defmodule Points.Plan.SubProject do
  @moduledoc """
  A version of Project that can be nested under other projects.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Points.Plan.Project

  @sub_project_statuses [:active, :archived]

  schema "projects" do
    field :position, :integer
    field :status, Ecto.Enum, values: @sub_project_statuses, default: :active
    field :title, :string

    belongs_to :parent, Project

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unsafe_validate_unique([:title, :parent_id], Points.Repo)
    |> unique_constraint([:title, :parent_id])
    |> cast_parent(attrs)
  end

  def cast_parent(changeset, %{"parent" => parent}), do: cast_parent(changeset, parent)
  def cast_parent(changeset, %Project{} = parent), do: put_assoc(changeset, :parent, parent)
  def cast_parent(changeset, %{parent: parent}), do: cast_parent(changeset, parent)
  def cast_parent(changeset, _), do: changeset

  def change_position(changeset, position) do
    put_change(changeset, :position, position)
  end

  def change_status(project) do
    cast(project, %{status: :archived}, [:status])
  end
end
