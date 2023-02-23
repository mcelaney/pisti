defmodule Points.ReportTest do
  use Points.DataCase
  import Points.ReportFixtures

  alias Points.Report
  alias Points.Report.Project
  alias Points.Report.SubProject

  describe "projects" do
    @invalid_attrs %{title: nil}

    test "list_projects/0 returns projects" do
      project = project_fixture()
      assert Report.list_projects() == [project]
    end

    test "list_projects/0 does not return archived projects" do
      project = project_fixture()
      _archived_project = project_fixture() |> Report.archive_project()
      assert Report.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Report.get_project!(project.id) == project |> Repo.preload(:sub_projects)
    end

    test "get_project!/1 does not return archived sub-projects" do
      project = project_fixture()
      sub_project = sub_project_fixture(%{parent: project})

      _archived_sub_project =
        sub_project_fixture(%{parent: project}) |> Report.archive_sub_project()

      %{sub_projects: [returned]} = Report.get_project!(project.id)
      assert returned.id == sub_project.id
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Project{} = project} = Report.create_project(valid_attrs)
      assert project.status == :active
      assert project.title == "some title"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Report.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Project{} = project} = Report.update_project(project, update_attrs)
      assert project.title == "some updated title"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Report.update_project(project, @invalid_attrs)
      assert Report.get_project!(project.id) == project |> Repo.preload(:sub_projects)
    end

    test "archive_project/1 changes the project status" do
      project = project_fixture()
      {:ok, result} = Report.archive_project(project)

      assert project.status == :active
      assert result.status == :archived
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Report.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Report.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Report.change_project(project)
    end
  end

  describe "sub_projects" do
    setup do
      %{parent: project_fixture()}
    end

    @invalid_attrs %{title: nil}

    test "get_sub_project!/1 returns the sub_project with given id" do
      sub_project = sub_project_fixture()
      assert Report.get_sub_project!(sub_project.parent_id, sub_project.id) == sub_project
    end

    test "create_sub_project/1 with valid data creates a sub_project", %{parent: parent} do
      valid_attrs = %{title: "some title"}

      assert {:ok, %SubProject{} = sub_project} = Report.create_sub_project(parent, valid_attrs)
      assert sub_project.status == :active
      assert sub_project.title == "some title"
      assert sub_project.position == 1
    end

    test "postion auto updates", %{parent: parent} do
      sub_project_fixture(%{parent: parent})
      valid_attrs = %{title: unique_sub_project_name()}

      assert {:ok, %SubProject{} = sub_project} = Report.create_sub_project(parent, valid_attrs)
      assert sub_project.position == 2
    end

    test "postion can be explicitly set", %{parent: parent} do
      sub_project_fixture(%{parent: parent})
      valid_attrs = %{title: unique_sub_project_name(), position: 42}

      assert {:ok, %SubProject{} = sub_project} = Report.create_sub_project(parent, valid_attrs)
      assert sub_project.position == 42
    end

    test "create_sub_project/1 with invalid data returns error changeset", %{parent: parent} do
      assert {:error, %Ecto.Changeset{}} = Report.create_sub_project(parent, @invalid_attrs)
    end

    test "update_sub_project/2 with valid data updates the sub_project" do
      sub_project = sub_project_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %SubProject{} = sub_project} =
               Report.update_sub_project(sub_project, update_attrs)

      assert sub_project.title == "some updated title"
    end

    test "update_sub_project/2 with invalid data returns error changeset" do
      sub_project = sub_project_fixture()
      assert {:error, %Ecto.Changeset{}} = Report.update_sub_project(sub_project, @invalid_attrs)
      assert Report.get_sub_project!(sub_project.parent_id, sub_project.id) == sub_project
    end

    test "archive_sub_project/1 changes the project status" do
      sub_project = sub_project_fixture()
      {:ok, result} = Report.archive_sub_project(sub_project)

      assert sub_project.status == :active
      assert result.status == :archived
    end

    test "delete_sub_project/1 deletes the sub_project" do
      sub_project = sub_project_fixture()
      assert {:ok, %SubProject{}} = Report.delete_sub_project(sub_project)

      assert_raise Ecto.NoResultsError, fn ->
        Report.get_sub_project!(sub_project.parent_id, sub_project.id)
      end
    end

    test "change_sub_project/1 returns a sub_project changeset" do
      sub_project = sub_project_fixture()
      assert %Ecto.Changeset{} = Report.change_sub_project(sub_project)
    end
  end
end
