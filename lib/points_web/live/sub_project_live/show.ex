defmodule PointsWeb.SubProjectLive.Show do
  use PointsWeb, :live_view

  alias Points.Plan
  alias Points.Plan.Ticket
  alias Points.Report

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{
         "project_id" => project_id,
         "sub_project_id" => sub_project_id
       }) do
    base_assigns(socket, project_id, sub_project_id)
  end

  defp apply_action(socket, :edit, %{
         "project_id" => project_id,
         "sub_project_id" => sub_project_id
       }) do
    base_assigns(socket, project_id, sub_project_id)
  end

  defp apply_action(socket, :new_ticket, %{
         "project_id" => project_id,
         "sub_project_id" => sub_project_id
       }) do
    socket
    |> base_assigns(project_id, sub_project_id)
    |> assign(:ticket, %Ticket{})
  end

  defp apply_action(socket, :edit_ticket, %{
         "project_id" => project_id,
         "sub_project_id" => sub_project_id,
         "ticket_id" => ticket_id
       }) do
    socket
    |> base_assigns(project_id, sub_project_id)
    |> assign(:ticket, Plan.get_ticket!(ticket_id))
  end

  @impl true
  def handle_event(
        "delete_ticket",
        %{
          "ticket_id" => ticket_id,
          "project_id" => _project_id,
          "sub_project_id" => sub_project_id
        },
        socket
      ) do
    ticket = Plan.get_ticket!(ticket_id)
    {:ok, _} = Plan.delete_ticket(ticket)

    {:noreply, assign(socket, :tickets, Plan.list_tickets_for_project(sub_project_id))}
  end

  defp base_assigns(socket, project_id, sub_project_id) do
    sub_project = Report.get_sub_project!(project_id, sub_project_id)
    tickets = Plan.list_tickets_for_project(sub_project)

    socket
    |> assign(:project, sub_project.parent)
    |> assign(:sub_project, sub_project)
    |> assign(:page_title, page_title(socket.assigns.live_action, sub_project))
    |> assign(:tickets, tickets)
  end

  defp page_title(:show, sub_project), do: sub_project.title
  defp page_title(:edit, sub_project), do: gettext("Edit %{title}", title: sub_project.title)

  defp page_title(:new_ticket, sub_project),
    do: gettext("New Ticket for %{title}", title: sub_project.title)

  defp page_title(:edit_ticket, _), do: gettext("Edit Ticket")
end
