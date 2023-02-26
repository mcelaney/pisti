defmodule PointsWeb.TicketLiveTest do
  use PointsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Points.PlanFixtures

  @update_attrs %{
    title: "some updated title",
    description: "some updated description",
    extra_info: "some updated information"
  }
  @invalid_attrs %{title: nil}

  defp create_ticket(_) do
    ticket = ticket_fixture()
    %{ticket: ticket}
  end

  describe "Show" do
    setup [:create_ticket, :register_confirm_and_log_in_member]

    test "displays ticket", %{conn: conn, ticket: ticket} do
      {:ok, _show_live, html} = live(conn, ~p"/tickets/#{ticket}")

      assert html =~ ticket.title
      assert html =~ ticket.description
      assert html =~ ticket.extra_info
    end

    test "updates ticket within modal", %{conn: conn, ticket: ticket} do
      {:ok, show_live, _html} = live(conn, ~p"/tickets/#{ticket}")

      assert show_live |> element("a", "Edit ticket") |> render_click() =~
               "Edit Ticket"

      assert_patch(show_live, ~p"/tickets/#{ticket}/edit")

      assert show_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#ticket-form", ticket: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tickets/#{ticket}")

      assert html =~ "Ticket updated successfully"
      assert html =~ "some updated title"
    end
  end
end
