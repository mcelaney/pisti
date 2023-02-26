defmodule PointsWeb.TicketLive.Show do
  use PointsWeb, :live_view

  alias Points.Plan
  alias Points.Report

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    ticket = Plan.get_ticket!(id)

    socket
    |> assign(:ticket, ticket)
    |> assign_projects(ticket)
    |> assign(:page_title, page_title(socket.assigns.live_action, ticket))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    ticket = Plan.get_ticket!(id)

    socket
    |> assign(:ticket, ticket)
    |> assign_projects(ticket)
    |> assign(:page_title, page_title(socket.assigns.live_action, ticket))
  end

  defp page_title(:show, ticket), do: ticket.title
  defp page_title(:edit, ticket), do: gettext("Edit Ticket", title: ticket.title)

  defp assign_projects(socket, %{project: %{id: project_id, parent_id: parent_id}})
       when is_nil(parent_id) do
    project = Report.get_project!(project_id)

    socket
    |> assign(:project, project)
    |> assign(:sub_project, nil)
  end

  defp assign_projects(socket, %{project: %{id: sub_project_id, parent_id: project_id}}) do
    sub_project = Report.get_sub_project!(project_id, sub_project_id)

    socket
    |> assign(:project, sub_project.parent)
    |> assign(:sub_project, sub_project)
  end
end
