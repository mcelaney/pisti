defmodule Points.Plan do
  @moduledoc """
  The Plan context.
  """

  import Ecto.Query, warn: false
  alias Points.Repo

  alias Points.Plan.Project
  alias Points.Plan.SubProject

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Project
    |> where([p], is_nil(p.parent_id) and p.status == :active)
    |> order_by([p], asc: p.title)
    |> Repo.all()
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id) do
    Project
    |> where([p], p.id == ^id)
    |> where([p], is_nil(p.parent_id) and p.status == :active)
    |> preload(
      sub_projects:
        ^from(
          sp in SubProject,
          where: sp.status == :active,
          order_by: [asc: sp.position]
        )
    )
    |> Repo.one!()
  end

  @doc """
  Gets a single sub-project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_sub_project!(123)
      %Project{}

      iex> get_sub_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sub_project!(parent_id, id) do
    SubProject
    |> where([p], p.parent_id == ^parent_id and p.id == ^id and p.status == :active)
    |> preload(:parent)
    |> Repo.one!()
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a sub-project for a given project.

  ## Examples

      iex> create_sub_project(%Project{}, %{field: value})
      {:ok, %Project{}}

      iex> create_sub_project(%Project{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sub_project(parent, attrs) do
    %SubProject{}
    |> SubProject.changeset(add_parent(attrs, parent))
    |> SubProject.change_position(next_position_for_sub_project(parent, attrs))
    |> Repo.insert()
  end

  defp add_parent(%{"title" => _} = attrs, parent), do: Map.put(attrs, "parent", parent)
  defp add_parent(attrs, parent), do: Map.put(attrs, :parent, parent)

  defp next_position_for_sub_project(_parent, %{position: position}) when is_integer(position),
    do: position

  defp next_position_for_sub_project(_parent, %{"position" => position})
       when is_integer(position),
       do: position

  defp next_position_for_sub_project(parent, _attrs) do
    Points.Plan.SubProject
    |> where([sp], sp.parent_id == ^parent.id)
    |> select([sp], max(sp.position))
    |> Repo.one()
    |> Kernel.||(0)
    |> Kernel.+(1)
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a sub project.

  ## Examples

      iex> update_sub_project(sub_project, %{field: new_value})
      {:ok, %SubProject{}}

      iex> update_sub_project(sub_project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sub_project(%SubProject{} = project, attrs) do
    project
    |> SubProject.changeset(attrs)
    |> Repo.update()
  end

  def archive_project(project) do
    project
    |> Project.change_status()
    |> Repo.update()
  end

  def archive_sub_project(project) do
    project
    |> SubProject.change_status()
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sub_project(%SubProject{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_sub_project(project)
      %Ecto.Changeset{data: %SubProject{}}

  """
  def change_sub_project(%SubProject{} = project, attrs \\ %{}) do
    SubProject.changeset(project, attrs)
  end
end
