defmodule PointsWeb.Router do
  use PointsWeb, :router

  import PointsWeb.UserAuth
  alias PointsWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PointsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PointsWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", PointsWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:points, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PointsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PointsWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", User.RegistrationLive, :new
      live "/users/log_in", User.LoginLive, :new
      live "/users/reset_password", User.ForgotPasswordLive, :new
      live "/users/reset_password/:token", User.ResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PointsWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{UserAuth, :ensure_authenticated}] do
      live "/users/settings", User.SettingsLive, :edit
      live "/users/settings/confirm_email/:token", User.SettingsLive, :confirm_email
    end

    live_session :planning,
      on_mount: [
        {UserAuth, :ensure_authenticated},
        {UserAuth, :ensure_confirmed},
        {UserAuth, :ensure_member_or_admin}
      ] do
      live "/projects", ProjectLive.Index, :index
      live "/projects/new", ProjectLive.Index, :new
      live "/projects/:id/edit_project", ProjectLive.Index, :edit_project

      live "/projects/:id", ProjectLive.Show, :show
      live "/projects/:id/edit", ProjectLive.Show, :edit
      live "/projects/:id/new_sub_project", ProjectLive.Show, :new_sub_project
      live "/projects/:parent_id/edit_sub_project/:id", ProjectLive.Show, :edit_sub_project

      live "/projects/:parent_id/sub_projects/:id", SubProjectLive.Show, :show
      live "/projects/:parent_id/sub_projects/:id/edit", SubProjectLive.Show, :edit
    end

    live_session :membership,
      on_mount: [
        {UserAuth, :ensure_authenticated},
        {UserAuth, :ensure_confirmed},
        {UserAuth, :ensure_admin}
      ] do
      live "/users", UserLive.Index, :index
    end
  end

  scope "/", PointsWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", User.ConfirmationLive, :edit
      live "/users/confirm", User.ConfirmationInstructionsLive, :new
    end
  end
end
