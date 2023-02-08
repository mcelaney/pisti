defmodule PointsWeb.UserLoginLive do
  use PointsWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        <%= gettext("Sign in to account") %>
        <:subtitle>
          <%= gettext("Don't have an account?") %>
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            <%= gettext("Sign up") %>
          </.link>
          <%= gettext("for an account now.") %>
        </:subtitle>
      </.header>

      <.simple_form
        :let={f}
        id="login_form"
        for={:user}
        action={~p"/users/log_in"}
        as={:user}
        phx-update="ignore"
      >
        <.input field={{f, :email}} type="email" label={gettext("Email")} required />
        <.input field={{f, :password}} type="password" label={gettext("Password")} required />

        <:actions :let={f}>
          <.input field={{f, :remember_me}} type="checkbox" label={gettext("Keep me logged in")} />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            <%= gettext("Forgot your password?") %>
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with={gettext("Sigining in...")} class="w-full">
            <%= gettext("Sign in") %> <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)

    {:ok, assign(socket, email: email, page_title: gettext("Sign In")),
     temporary_assigns: [email: nil]}
  end
end
