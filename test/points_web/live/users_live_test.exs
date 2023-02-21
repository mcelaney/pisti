defmodule PointsWeb.UsersLiveTest do
  use PointsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Points.AccountsFixtures
  alias Points.Accounts

  defp create_users(_) do
    %{
      archived: archived_fixture(),
      joined: joined_fixture(),
      member: member_fixture(),
      admin: admin_fixture()
    }
  end

  describe "Index" do
    setup [:create_users, :register_and_log_in_admin]

    test "lists all users", %{conn: conn, archived: archived, joined: joined, member: member, admin: admin} do
      {:ok, _index_live, html} = live(conn, ~p"/users")

      assert html =~ "Listing Users"

      assert html =~ archived.email
      assert html =~ joined.email
      assert html =~ member.email
      assert html =~ admin.email
    end

    test "Members can be promoted", %{conn: conn, member: user} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{user.id} a", "Promote") |> render_click()
      assert Accounts.get_user!(user.id).role == :admin
    end

    test "Members can be archived", %{conn: conn, member: user} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{user.id} a", "Archive") |> render_click()
      assert Accounts.get_user!(user.id).role == :archived
    end

    test "Admins can be demoted", %{conn: conn, admin: user} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{user.id} a", "Demote") |> render_click()
      assert Accounts.get_user!(user.id).role == :member
    end

    test "New users can be promoted", %{conn: conn, joined: user} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{user.id} a", "Promote") |> render_click()
      assert Accounts.get_user!(user.id).role == :member
    end

    test "Archived users can be promoted", %{conn: conn, archived: user} do
      {:ok, index_live, _html} = live(conn, ~p"/users")

      assert index_live |> element("#users-#{user.id} a", "Restore") |> render_click()
      assert Accounts.get_user!(user.id).role == :member
    end
  end
end
