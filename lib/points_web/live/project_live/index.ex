defmodule PointsWeb.ProjectLive.Index do
  use PointsWeb, :live_view

  alias Points.Report
  alias Points.Report.Project

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Listing Projects") %>
      <:actions>
        <.link patch={~p"/projects/new"}>
          <.button><%= gettext("New Project") %></.button>
        </.link>
      </:actions>
    </.header>

    <.table id="projects" rows={@projects} row_click={&JS.navigate(~p"/projects/#{&1}")}>
      <:col :let={project} label={gettext("Title")}><%= project.title %></:col>
      <:action :let={project}>
        <div class="sr-only">
          <.link navigate={~p"/projects/#{project}"}><%= gettext("Show") %></.link>
        </div>
        <.link patch={~p"/projects/#{project}/edit_project"}><%= gettext("Edit") %></.link>
      </:action>
      <:action :let={project}>
        <.link
          phx-click={JS.push("delete", value: %{id: project.id})}
          data-confirm={gettext("Are you sure?")}
        >
          <%= gettext("Delete") %>
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit_project]}
      id="project-modal"
      show
      on_cancel={JS.navigate(~p"/projects")}
    >
      <.live_component
        module={PointsWeb.ProjectLive.FormComponent}
        id={@project.id || :new}
        title={@page_title}
        action={@live_action}
        project={@project}
        navigate={~p"/projects"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :projects, list_projects())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit_project, %{"id" => id}) do
    project = Report.get_active_project_with_sub_projects!(id)

    socket
    |> assign(:page_title, gettext("Edit %{title}", title: project.title))
    |> assign(:project, project)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, gettext("New Project"))
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Projects"))
    |> assign(:project, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    project = Report.get_active_project_with_sub_projects!(id)
    {:ok, _} = Report.delete_project(project)

    {:noreply, assign(socket, :projects, list_projects())}
  end

  defp list_projects do
    Report.list_projects()
  end
end
