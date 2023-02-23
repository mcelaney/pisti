defmodule PointsWeb.ProjectLive.FormComponent do
  use PointsWeb, :live_component

  alias Points.Report

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="project-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :title}} type="text" label={gettext("Title")} />
        <:actions>
          <.button phx-disable-with={gettext("Saving...")}><%= gettext("Save Project") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{project: project} = assigns, socket) do
    changeset = Report.change_project(project)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> Report.change_project(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  defp save_project(socket, :edit_project, project_params) do
    save_project(socket, :edit, project_params)
  end

  defp save_project(socket, :edit, project_params) do
    case Report.update_project(socket.assigns.project, project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Project updated successfully"))
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_project(socket, :new, project_params) do
    case Report.create_project(project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Project created successfully"))
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
