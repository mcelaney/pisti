defmodule PointsWeb.ProjectLive.Show do
  use PointsWeb, :live_view

  alias Points.Plan
  alias Points.Plan.Ticket
  alias Points.Report
  alias Points.Report.SubProject

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"project_id" => project_id}) do
    base_assigns(socket, project_id)
  end

  defp apply_action(socket, :edit, %{"project_id" => project_id}) do
    base_assigns(socket, project_id)
  end

  defp apply_action(socket, :new_sub_project, %{"project_id" => project_id}) do
    socket
    |> base_assigns(project_id)
    |> assign(:sub_project, %SubProject{})
  end

  defp apply_action(socket, :edit_sub_project, %{
         "project_id" => project_id,
         "sub_project_id" => sub_project_id
       }) do
    sub_project = Report.get_sub_project!(project_id, sub_project_id)

    socket
    |> base_assigns(project_id)
    |> assign(:sub_project, sub_project)
  end

  defp apply_action(socket, :new_ticket, %{"project_id" => project_id}) do
    socket
    |> base_assigns(project_id)
    |> assign(:ticket, %Ticket{})
  end

  defp apply_action(socket, :edit_ticket, %{"project_id" => project_id, "ticket_id" => ticket_id}) do
    socket
    |> base_assigns(project_id)
    |> assign(:ticket, Plan.get_ticket!(ticket_id))
  end

  @impl true
  def handle_event(
        "delete_sub_project",
        %{"sub_project_id" => id, "project_id" => project_id},
        socket
      ) do
    sub_project = Report.get_sub_project!(project_id, id)
    {:ok, _} = Report.delete_sub_project(sub_project)

    {:noreply, assign(socket, :sub_projects, Report.list_active_sub_projects(project_id))}
  end

  def handle_event("delete_ticket", %{"ticket_id" => id, "project_id" => project_id}, socket) do
    ticket = Plan.get_ticket!(id)
    {:ok, _} = Plan.delete_ticket(ticket)

    {:noreply, assign(socket, :tickets, Plan.list_tickets_for_project(project_id))}
  end

  defp base_assigns(socket, project_id) do
    project = Report.get_active_project_with_sub_projects!(project_id)
    tickets = Plan.list_tickets_for_project(project)

    socket
    |> assign(:project, project)
    |> assign(:sub_projects, project.sub_projects)
    |> assign(:tickets, tickets)
    |> assign(:page_title, page_title(socket.assigns.live_action, project))
  end

  defp page_title(:show, project), do: project.title
  defp page_title(:edit, project), do: gettext("Edit %{title}", title: project.title)

  defp page_title(:new_sub_project, project),
    do: gettext("New Sub-Project for %{title}", title: project.title)

  defp page_title(:edit_sub_project, sub_project),
    do: gettext("Edit %{title}", title: sub_project.title)

  defp page_title(:new_ticket, project),
    do: gettext("New Ticket for %{title}", title: project.title)

  defp page_title(:edit_ticket, _),
    do: gettext("Edit Ticket")
end
