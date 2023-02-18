defmodule PointsWeb.ProjectLive.Show do
  use PointsWeb, :live_view

  alias Points.Plan
  alias Points.Plan.Project
  alias Points.Plan.SubProject

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:sub_project, %Project{})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    project = Plan.get_project!(id)

    socket
    |> assign(:project, project)
    |> assign(:page_title, page_title(socket.assigns.live_action, project))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    project = Plan.get_project!(id)

    socket
    |> assign(:project, project)
    |> assign(:page_title, page_title(socket.assigns.live_action, project))
  end

  defp apply_action(socket, :new_sub_project, %{"id" => id}) do
    project = Plan.get_project!(id)

    socket
    |> assign(:project, project)
    |> assign(:sub_project, %SubProject{})
    |> assign(:page_title, page_title(socket.assigns.live_action, project))
  end

  defp apply_action(socket, :edit_sub_project, %{"parent_id" => parent_id, "id" => id}) do
    sub_project = Plan.get_sub_project!(parent_id, id)
    project = Plan.get_project!(parent_id)

    socket
    |> assign(:project, project)
    |> assign(:sub_project, sub_project)
    |> assign(:page_title, page_title(socket.assigns.live_action, sub_project))
  end

  defp page_title(:show, project), do: project.title
  defp page_title(:edit, project), do: gettext("Edit %{title}", title: project.title)

  defp page_title(:new_sub_project, project),
    do: gettext("New Sub-Project for %{title}", title: project.title)

  defp page_title(:edit_sub_project, sub_project),
    do: gettext("Edit %{title}", title: sub_project.title)
end
