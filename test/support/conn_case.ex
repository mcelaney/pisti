defmodule PointsWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use PointsWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  alias Points.Accounts.User
  alias Points.Repo

  using do
    quote do
      # The default endpoint for testing
      @endpoint PointsWeb.Endpoint

      use PointsWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import PointsWeb.ConnCase
    end
  end

  setup tags do
    Points.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in users.

      setup :register_and_log_in_user

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_user(%{conn: conn}) do
    user = Points.AccountsFixtures.user_fixture()
    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Setup helper that registers and logs in pre-member users.

      setup :register_confirm_and_log_in_joined

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_confirm_and_log_in_joined(%{conn: conn}) do
    {:ok, user} =
      Points.AccountsFixtures.joined_fixture()
      |> User.confirm_changeset()
      |> Repo.update()

    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Setup helper that registers and logs in members.

      setup :register_confirm_and_log_in_member

  It stores an updated connection and a registered member in the
  test context.
  """
  def register_confirm_and_log_in_member(%{conn: conn}) do
    {:ok, user} =
      Points.AccountsFixtures.member_fixture()
      |> User.confirm_changeset()
      |> Repo.update()

    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Setup helper that registers and logs in admins.

      setup :register_confirm_and_log_in_admin

  It stores an updated connection and a registered admin in the
  test context.
  """
  def register_confirm_and_log_in_admin(%{conn: conn}) do
    {:ok, user} =
      Points.AccountsFixtures.admin_fixture()
      |> User.confirm_changeset()
      |> Repo.update()

    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    token = Points.Accounts.generate_user_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end
end
