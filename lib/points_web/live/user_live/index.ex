defmodule PointsWeb.UserLive.Index do
  use PointsWeb, :live_view

  import PointsWeb.UserLive.RoleComponents

  alias Points.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <%= gettext("Listing Users") %>
    </.header>

    <.table id="users" rows={@users}>
      <:col :let={user} label={gettext("Email")}><%= user.email %></:col>
      <:col :let={user} label={gettext("Role")}><%= role_label(user.role) %></:col>
      <:action :let={user}>
        <.role_links user={user} current_user={@current_user} />
      </:action>
    </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :users, list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, gettext("Listing Users"))
  end

  @impl true
  def handle_event("archive", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.set_archived(user)

    {:noreply, assign(socket, :users, list_users())}
  end

  def handle_event("change_to_admin", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.set_admin(user)

    {:noreply, assign(socket, :users, list_users())}
  end

  def handle_event("change_to_member", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.set_member(user)

    {:noreply, assign(socket, :users, list_users())}
  end

  defp list_users do
    Accounts.list_users()
  end
end
