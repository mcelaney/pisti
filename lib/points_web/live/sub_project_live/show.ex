defmodule PointsWeb.SubProjectLive.Show do
  use PointsWeb, :live_view

  alias Points.Report
  alias Points.Report.Project

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"parent_id" => parent_id, "id" => id}) do
    sub_project = Report.get_sub_project!(parent_id, id)

    socket
    |> assign(:parent, sub_project.parent)
    |> assign(:sub_project, sub_project)
    |> assign(:page_title, page_title(socket.assigns.live_action, sub_project))
  end

  defp apply_action(socket, :edit, %{"parent_id" => parent_id, "id" => id}) do
    sub_project = Report.get_sub_project!(parent_id, id)

    socket
    |> assign(:parent, sub_project.parent)
    |> assign(:sub_project, sub_project)
    |> assign(:page_title, page_title(socket.assigns.live_action, sub_project))
  end

  defp page_title(:show, sub_project), do: sub_project.title
  defp page_title(:edit, sub_project), do: gettext("Edit %{title}", title: sub_project.title)
end
