defmodule PointsWeb.ProjectLiveTest do
  use PointsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Points.PlanFixtures

  @create_attrs %{
    title: "some title"
  }
  @update_attrs %{
    title: "some updated title"
  }
  @invalid_attrs %{title: nil}

  defp create_project(_) do
    project = project_fixture()
    %{project: project}
  end

  describe "Index" do
    setup [:create_project, :register_confirm_and_log_in_member]

    test "lists all projects", %{conn: conn, project: project} do
      {:ok, _index_live, html} = live(conn, ~p"/projects")

      assert html =~ "Listing Projects"
      assert html =~ project.title
    end

    test "saves new project", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/projects")

      assert index_live |> element("a", "New Project") |> render_click() =~
               "New Project"

      assert_patch(index_live, ~p"/projects/new")

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#project-form", project: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/projects")

      assert html =~ "Project created successfully"
      assert html =~ "some title"
    end

    test "updates project in listing", %{conn: conn, project: project} do
      {:ok, index_live, _html} = live(conn, ~p"/projects")

      assert index_live |> element("#projects-#{project.id} a", "Edit") |> render_click() =~
               "Edit #{project.title}"

      assert_patch(index_live, ~p"/projects/#{project}/edit_project")

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#project-form", project: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/projects")

      assert html =~ "Project updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes project in listing", %{conn: conn, project: project} do
      {:ok, index_live, _html} = live(conn, ~p"/projects")

      assert index_live |> element("#projects-#{project.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#project-#{project.id}")
    end
  end

  describe "Show" do
    setup [:create_project, :register_confirm_and_log_in_member]

    test "displays project", %{conn: conn, project: project} do
      {:ok, _show_live, html} = live(conn, ~p"/projects/#{project}")

      assert html =~ project.title
    end

    test "saves new sub project", %{conn: conn, project: project} do
      {:ok, show_live, _html} = live(conn, ~p"/projects/#{project}")

      assert show_live |> element("a", "Add Sub-Project") |> render_click() =~
               "New Sub-Project"

      assert_patch(show_live, ~p"/projects/#{project}/new_sub_project")

      assert show_live
             |> form("#sub-project-form", sub_project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#sub-project-form", sub_project: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/projects/#{project}")

      assert html =~ "Sub-project created successfully"
      assert html =~ "some title"
    end

    test "updates project within modal", %{conn: conn, project: project} do
      {:ok, show_live, _html} = live(conn, ~p"/projects/#{project}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit #{project.title}"

      assert_patch(show_live, ~p"/projects/#{project}/edit")

      assert show_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#project-form", project: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/projects/#{project}")

      assert html =~ "Project updated successfully"
      assert html =~ "some updated title"
    end

    test "updates sub-project within modal", %{conn: conn, project: project} do
      sub_project = sub_project_fixture(%{parent: project})
      {:ok, show_live, _html} = live(conn, ~p"/projects/#{project}")

      assert show_live
             |> element("#sub_projects-#{sub_project.id} a", "Edit")
             |> render_click() =~ "Edit #{sub_project.title}"

      assert_patch(show_live, ~p"/projects/#{project}/edit_sub_project/#{sub_project}")

      assert show_live
             |> form("#sub-project-form", sub_project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#sub-project-form", sub_project: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/projects/#{project}")

      assert html =~ "Sub-project updated successfully"
      assert html =~ "some updated title"
    end
  end

  describe "Unauthorized Index" do
    setup [:register_confirm_and_log_in_joined]

    test "rejects unauthorized users", %{conn: conn} do
      {:error, {:redirect, %{flash: %{"error" => flash}}}} = live(conn, ~p"/projects")

      assert flash =~ "must be confirmed"
    end
  end
end
