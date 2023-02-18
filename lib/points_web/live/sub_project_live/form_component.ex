defmodule PointsWeb.SubProjectLive.FormComponent do
  use PointsWeb, :live_component

  alias Points.Plan

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
        id="sub-project-form"
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
  def update(%{sub_project: sub_project} = assigns, socket) do
    changeset = Plan.change_sub_project(sub_project)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"sub_project" => project_params}, socket) do
    changeset =
      socket.assigns.sub_project
      |> Plan.change_sub_project(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"sub_project" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  defp save_project(socket, :new_sub_project, project_params) do
    case Plan.create_sub_project(socket.assigns.parent, project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Sub-project created successfully"))
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_project(socket, :edit_sub_project, project_params) do
    save_project(socket, :edit, project_params)
  end

  defp save_project(socket, :edit, project_params) do
    case Plan.update_sub_project(socket.assigns.sub_project, project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Sub-project updated successfully"))
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
