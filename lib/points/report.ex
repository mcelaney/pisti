defmodule Points.Report do
  @moduledoc """
  The Report context organizes projects and sub-projects for whole-report export
  """

  import Ecto.Query, warn: false

  alias Points.Repo
  alias Points.Report.Project
  alias Points.Report.SubProject

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
  Returns the list of projects.

  ## Examples

      iex> list_active_sub_projects(1)
      [%SubProject{}, ...]

      iex> list_active_sub_projects(%Project{})
      [%SubProject{}, ...]

  """
  def list_active_sub_projects(%Project{id: project_id}), do: list_active_sub_projects(project_id)

  def list_active_sub_projects(project_id) do
    SubProject
    |> where([p], p.parent_id == ^project_id and p.status == :active)
    |> order_by([p], asc: p.position)
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
    |> where([p], is_nil(p.parent_id))
    |> Repo.one!()
  end

  @doc """
  Gets a single project with it's subprojects preloaded.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_active_project_with_sub_projects!(123)
      %Project{}

      iex> get_active_project_with_sub_projects!(456)
      ** (Ecto.NoResultsError)

  """
  def get_active_project_with_sub_projects!(id) do
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
    |> SubProject.changeset(add_parent_to_attrs(attrs, parent))
    |> SubProject.change_position(next_position_for_sub_project(parent, attrs))
    |> Repo.insert()
  end

  defp add_parent_to_attrs(%{"title" => _} = attrs, parent), do: Map.put(attrs, "parent", parent)
  defp add_parent_to_attrs(attrs, parent), do: Map.put(attrs, :parent, parent)

  defp next_position_for_sub_project(_parent, %{position: position}) when is_integer(position),
    do: position

  defp next_position_for_sub_project(_parent, %{"position" => position})
       when is_integer(position),
       do: position

  defp next_position_for_sub_project(parent, _attrs) do
    SubProject
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
