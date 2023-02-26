defmodule PointsWeb.TicketLive.FormComponent do
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
        id="ticket-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :title}} type="text" label={gettext("Title")} />
        <.input field={{f, :description}} type="textarea" label={gettext("Description")} />
        <.input field={{f, :extra_info}} type="textarea" label={gettext("Extra Info")} />
        <:actions>
          <.button phx-disable-with={gettext("Saving...")}><%= gettext("Save Ticket") %></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{ticket: ticket} = assigns, socket) do
    changeset = Plan.change_ticket(ticket)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"ticket" => project_params}, socket) do
    changeset =
      socket.assigns.ticket
      |> Plan.change_ticket(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"ticket" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  defp save_project(socket, :new_ticket, project_params) do
    case Plan.create_ticket(socket.assigns.project, project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Ticket created successfully"))
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_project(socket, :edit_ticket, project_params) do
    save_project(socket, :edit, project_params)
  end

  defp save_project(socket, :edit, project_params) do
    case Plan.update_ticket(socket.assigns.ticket, project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Ticket updated successfully"))
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
