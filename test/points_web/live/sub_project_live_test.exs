defmodule PointsWeb.SubProjectLiveTest do
  use PointsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Points.ReportFixtures
  import Points.PlanFixtures

  @update_attrs %{
    title: "some updated title"
  }
  @invalid_attrs %{title: nil}

  @create_ticket_attrs %{
    title: "some ticket title",
    description: "some ticket description",
    extra_info: "some ticket information"
  }

  @update_ticket_attrs %{
    title: "some updated ticket title",
    description: "some updated ticket description",
    extra_info: "some updated ticket information"
  }

  defp create_sub_project(_) do
    sub_project = sub_project_fixture()
    %{sub_project: sub_project}
  end

  describe "Show" do
    setup [:create_sub_project, :register_confirm_and_log_in_member]

    test "displays sub-project", %{conn: conn, sub_project: sub_project} do
      {:ok, _show_live, html} =
        live(conn, ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}")

      assert html =~ sub_project.parent.title
      assert html =~ sub_project.title
    end

    test "updates sub-project within modal", %{conn: conn, sub_project: sub_project} do
      {:ok, show_live, _html} =
        live(conn, ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit #{sub_project.title}"

      assert_patch(
        show_live,
        ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}/edit"
      )

      assert show_live
             |> form("#sub-project-form", sub_project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#sub-project-form", sub_project: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}")

      assert html =~ "Sub-project updated successfully"
      assert html =~ "some updated title"
    end

    test "saves new ticket", %{conn: conn, sub_project: sub_project} do
      {:ok, show_live, _html} =
        live(conn, ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}")

      assert show_live |> element("a", "Add Ticket") |> render_click() =~
               "New Ticket"

      assert_patch(
        show_live,
        ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}/new_ticket"
      )

      assert show_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#ticket-form", ticket: @create_ticket_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}")

      assert html =~ "Ticket created successfully"
      assert html =~ "some ticket title"
    end

    test "updates ticket within modal", %{conn: conn, sub_project: sub_project} do
      ticket = ticket_fixture(sub_project)

      {:ok, show_live, _html} =
        live(conn, ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}")

      assert show_live
             |> element("#tickets-#{ticket.id} a", "Edit")
             |> render_click() =~ "Edit"

      assert_patch(
        show_live,
        ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}/edit_ticket/#{ticket}"
      )

      assert show_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#ticket-form", ticket: @update_ticket_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}")

      assert html =~ "Ticket updated successfully"
      assert html =~ "some updated ticket title"
    end

    test "deletes ticket in listing", %{conn: conn, sub_project: sub_project} do
      ticket = ticket_fixture(sub_project)

      {:ok, show_live, _html} =
        live(conn, ~p"/projects/#{sub_project.parent}/sub_projects/#{sub_project}")

      assert show_live |> element("#tickets-#{ticket.id} a", "Delete") |> render_click()
      refute has_element?(show_live, "#ticket-#{ticket.id}")
    end
  end
end
