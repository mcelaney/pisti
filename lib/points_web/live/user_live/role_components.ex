defmodule PointsWeb.UserLive.RoleComponents do
  use Phoenix.Component
  import PointsWeb.Gettext
  alias Phoenix.LiveView.JS

  def role_links(%{current_user: %{id: id}, user: %{id: id}} = assigns) do
    ~H"""
    (<%= gettext("Self") %>)
    """
  end

  def role_links(%{user: %{role: :archived} = user} = assigns) do
    ~H"""
      <.build_link user={@user} role_action="change_to_member" label={gettext("Restore")} />
    """
  end

  def role_links(%{user: %{role: :joined} = user} = assigns) do
    ~H"""
      <.build_link user={@user} role_action="change_to_member" label={gettext("Promote")} />
    """
  end

  def role_links(%{user: %{role: :member} = user} = assigns) do
    ~H"""
      <.build_link user={@user} role_action="archive" label={gettext("Archive")} />
      |
      <.build_link user={@user} role_action="change_to_admin" label={gettext("Promote")} />
    """
  end

  def role_links(%{user: %{role: :admin} = user} = assigns) do
    ~H"""
      <.build_link user={@user} role_action="change_to_member" label={gettext("Demote")} />
    """
  end

  def build_link(assigns) do
    ~H"""
      <.link
        phx-click={JS.push(@role_action, value: %{id: @user.id})}
        data-confirm={gettext("Are you sure?")}
        class="underline"
      >
        <%= @label %>
      </.link>
    """
  end

  def role_label(:archived), do: gettext("Archived")
  def role_label(:joined), do: gettext("Joined")
  def role_label(:member), do: gettext("Member")
  def role_label(:admin), do: gettext("Admin")
end
