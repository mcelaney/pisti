defmodule Points.Plan.Project do
  @moduledoc """
  A folder for stories
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Points.Plan.SubProject

  @project_statuses [:active, :archived]

  schema "projects" do
    field :status, Ecto.Enum, values: @project_statuses, default: :active
    field :title, :string
    # should always be nil - included so unique_constraint works properly
    field :parent_id, :integer

    has_many :sub_projects, SubProject, foreign_key: :parent_id, references: :id

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unsafe_validate_unique([:title, :parent_id], Points.Repo)
    |> unique_constraint([:title, :parent_id])
  end

  def change_status(project) do
    cast(project, %{status: :archived}, [:status])
  end
end
