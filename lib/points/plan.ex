defmodule Points.Plan do
  @moduledoc """
  The Plan context manages ticket information
  """

  import Ecto.Query, warn: false

  alias Points.Plan.Project
  alias Points.Plan.Ticket
  alias Points.Repo
  alias Points.Report.Project, as: ReportProject
  alias Points.Report.SubProject, as: ReportSubProject

  @doc """
  Returns a Plan.Project

  In the planning context there is no difference between Project and SubProject
  since both concepts live in the same table

  ## Examples

      iex> get_project!(project_id)
      %Points.Plan.Project{}

      iex> get_project!(%Points.Report.Project{})
      %Points.Plan.Project{}

      iex> get_project!(%Points.Report.SubProject{})
      %Points.Plan.Project{}

      iex> get_project!(%Points.Plan.Project{})
      %Points.Plan.Project{}
  """
  def get_project!(project_id) when is_integer(project_id) do
    Repo.get!(Project, project_id)
  end

  def get_project!(%Project{} = project), do: project

  def get_project!(%ReportProject{} = project), do: struct(Project, Map.from_struct(project))

  def get_project!(%ReportSubProject{} = project), do: struct(Project, Map.from_struct(project))

  @doc """
  Returns a single ticket with a preloaded Project

  Raises `Ecto.NoResultsError` if the Ticket does not exist.

  ## Examples

      iex> get_ticket!(123)
      %Project{}

      iex> get_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ticket!(id) do
    Ticket
    |> where([t], t.id == ^id)
    |> preload(:project)
    |> Repo.one!()
  end

  @doc """
  Returns the tickets for a project.

  ## Examples

      iex> list_tickets_for_project(%Points.Plan.Project{})
      [%Ticket{}, ...]

      iex> list_tickets_for_project(%Points.Report.Project{})
      [%Ticket{}, ...]

      iex> list_tickets_for_project(%Points.Report.SubProject{})
      [%Ticket{}, ...]

      iex> list_tickets_for_project(project_id)
      [%Ticket{}, ...]

  """
  def list_tickets_for_project(%{id: project_id}), do: list_tickets_for_project(project_id)

  def list_tickets_for_project(project_id) do
    Ticket
    |> where([t], t.project_id == ^project_id)
    |> order_by([t], t.position)
    |> Repo.all()
  end

  @doc """
  Creates a new ticket for a given project

  ## Examples

      iex> create_ticket(%Points.Plan.Project{}, %{field: value})
      {:ok, %Project{}}

      iex> create_ticket(%Points.Report.Project{}, %{field: value})
      {:ok, %Project{}}

      iex> create_ticket(%Points.Report.SubProject{}, %{field: value})
      {:ok, %Project{}}

      iex> create_ticket(project_id, %{field: value})
      {:ok, %Project{}}

      iex> create_ticket(project_id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket(project, attrs) do
    plan_project = get_project!(project)

    %Ticket{}
    |> Ticket.changeset(add_project_to_attrs(attrs, plan_project))
    |> Ticket.change_position(next_position_for_ticket(plan_project, attrs))
    |> Repo.insert()
  end

  defp add_project_to_attrs(%{"title" => _} = attrs, project) do
    Map.put(attrs, "project", get_project!(project))
  end

  defp add_project_to_attrs(%{title: _} = attrs, project) do
    Map.put(attrs, :project, get_project!(project))
  end

  defp next_position_for_ticket(_project, %{position: position}) when is_integer(position),
    do: position

  defp next_position_for_ticket(_project, %{"position" => position})
       when is_integer(position),
       do: position

  defp next_position_for_ticket(%{id: project_id}, _attrs) do
    Ticket
    |> where([t], t.project_id == ^project_id)
    |> select([t], max(t.position))
    |> Repo.one()
    |> Kernel.||(0)
    |> Kernel.+(1)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket changes.

  ## Examples

      iex> change_ticket(ticket)
      %Ecto.Changeset{data: %Ticket{}}

  """
  def change_ticket(%Ticket{} = ticket, attrs \\ %{}) do
    Ticket.changeset(ticket, attrs)
  end

  @doc """
  Deletes a ticket.

  ## Examples

      iex> delete_ticket(ticket)
      {:ok, %Ticket{}}

      iex> delete_ticket(ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket(%Ticket{} = ticket) do
    Repo.delete(ticket)
  end

  @doc """
  Updates a ticket.

  ## Examples

      iex> update_ticket(ticket, %{field: new_value})
      {:ok, %Ticket{}}

      iex> update_ticket(ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket(%Ticket{} = ticket, attrs) do
    ticket
    |> Ticket.changeset(attrs)
    |> Repo.update()
  end
end
