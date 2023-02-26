defmodule Points.PlanTest do
  use Points.DataCase
  import Points.PlanFixtures

  alias Points.Plan
  alias Points.Plan.Project
  alias Points.Plan.Ticket

  describe "projects" do
    setup do
      report_sub_project = Points.ReportFixtures.sub_project_fixture()
      report_project = Points.ReportFixtures.project_fixture()

      %{
        report_sub_project: report_sub_project,
        report_project: report_project,
        project: Points.Repo.get!(Project, report_project.id),
        sub_project: Points.Repo.get!(Project, report_sub_project.id),
        ticket: ticket_fixture()
      }
    end

    test "get_project!/1 given a project Plan.Project returns a project", %{project: project} do
      assert Plan.get_project!(project) == project
    end

    test "get_project!/1 given a sub-project Plan.Project returns a project", %{
      sub_project: sub_project
    } do
      assert Plan.get_project!(sub_project) == sub_project
    end

    test "get_project!/1 given a Report.Project returns a project", %{
      report_project: report_project,
      project: project
    } do
      %Points.Plan.Project{id: id} = Plan.get_project!(report_project)
      assert id == project.id
    end

    test "get_project!/1 given a Report.SubProject returns a project", %{
      report_sub_project: report_sub_project,
      sub_project: sub_project
    } do
      %Points.Plan.Project{id: id, parent_id: parent_id} = Plan.get_project!(report_sub_project)
      assert id == sub_project.id
      assert parent_id == sub_project.parent_id
    end

    test "get_project!/1 given a project_id returns a project", %{
      project: %{id: project_id} = project
    } do
      assert Plan.get_project!(project_id) == project
    end

    test "get_project!/1 raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Plan.get_project!(-1)
      end
    end
  end

  describe "tickets" do
    setup do
      report_sub_project = Points.ReportFixtures.sub_project_fixture()
      report_project = Points.ReportFixtures.project_fixture()

      %{
        report_sub_project: report_sub_project,
        report_project: report_project,
        project: Points.Repo.get!(Project, report_project.id),
        sub_project: Points.Repo.get!(Project, report_sub_project.id),
        ticket: ticket_fixture()
      }
    end

    test "get_ticket!/1", %{ticket: ticket} do
      assert Plan.get_ticket!(ticket.id) == ticket
    end

    test "get_ticket!/1 raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Plan.get_ticket!(-1)
      end
    end

    test "list_tickets_for_project/1 given a project Plan.Project", %{project: project} do
      ticket = ticket_fixture(project)
      [%Ticket{} = result] = Plan.list_tickets_for_project(project)
      assert result.id == ticket.id
    end

    test "list_tickets_for_project/1 given a sub-project Plan.Project", %{sub_project: project} do
      ticket = ticket_fixture(project)
      [%Ticket{} = result] = Plan.list_tickets_for_project(project)
      assert result.id == ticket.id
    end

    test "list_tickets_for_project/1 given a Report.Project", %{
      report_project: report_project,
      project: project
    } do
      ticket = ticket_fixture(project)
      [%Ticket{} = result] = Plan.list_tickets_for_project(report_project)
      assert result.id == ticket.id
    end

    test "list_tickets_for_project/1 given a Report.SubProject", %{
      report_sub_project: report_sub_project,
      sub_project: project
    } do
      ticket = ticket_fixture(project)
      [%Ticket{} = result] = Plan.list_tickets_for_project(report_sub_project)
      assert result.id == ticket.id
    end

    test "list_tickets_for_project/1 given a project_id", %{project: %{id: project_id} = project} do
      ticket = ticket_fixture(project)
      [%Ticket{} = result] = Plan.list_tickets_for_project(project_id)
      assert result.id == ticket.id
    end

    test "create_ticket/2 given a Plan.Project based on Report.Project", %{project: project} do
      valid_attrs = %{
        title: "some title",
        description: "some description",
        extra_info: "some extra_info"
      }

      assert {:ok, %Ticket{} = ticket} = Plan.create_ticket(project, valid_attrs)
      assert ticket.title == "some title"
      assert ticket.position == 1
      assert ticket.description == "some description"
      assert ticket.extra_info == "some extra_info"
      assert ticket.project_id == project.id
    end

    test "create_ticket/2 given a Plan.Project based on Report.SubProject", %{
      sub_project: project
    } do
      valid_attrs = %{
        title: "some title",
        description: "some description",
        extra_info: "some extra_info"
      }

      assert {:ok, %Ticket{} = ticket} = Plan.create_ticket(project, valid_attrs)
      assert ticket.title == "some title"
      assert ticket.position == 1
      assert ticket.description == "some description"
      assert ticket.extra_info == "some extra_info"
      assert ticket.project_id == project.id
    end

    test "create_ticket/2 given a Report.Project", %{report_project: project} do
      valid_attrs = %{
        title: "some title",
        description: "some description",
        extra_info: "some extra_info"
      }

      assert {:ok, %Ticket{} = ticket} = Plan.create_ticket(project, valid_attrs)
      assert ticket.title == "some title"
      assert ticket.position == 1
      assert ticket.description == "some description"
      assert ticket.extra_info == "some extra_info"
      assert ticket.project_id == project.id
    end

    test "create_ticket/2 given a Report.SubProject", %{report_sub_project: project} do
      valid_attrs = %{
        title: "some title",
        description: "some description",
        extra_info: "some extra_info"
      }

      assert {:ok, %Ticket{} = ticket} = Plan.create_ticket(project, valid_attrs)
      assert ticket.title == "some title"
      assert ticket.position == 1
      assert ticket.description == "some description"
      assert ticket.extra_info == "some extra_info"
      assert ticket.project_id == project.id
    end

    test "create_ticket/2 given a project_id", %{project: %{id: project_id}} do
      valid_attrs = %{
        title: "some title",
        description: "some description",
        extra_info: "some extra_info"
      }

      assert {:ok, %Ticket{} = ticket} = Plan.create_ticket(project_id, valid_attrs)
      assert ticket.title == "some title"
      assert ticket.position == 1
      assert ticket.description == "some description"
      assert ticket.extra_info == "some extra_info"
      assert ticket.project_id == project_id
    end

    test "delete_ticket/1 deletes the ticket" do
      ticket = ticket_fixture()
      assert {:ok, %Ticket{}} = Plan.delete_ticket(ticket)

      assert_raise Ecto.NoResultsError, fn ->
        Plan.get_ticket!(ticket.id)
      end
    end

    test "update_ticket/2 with valid data updates the ticket" do
      ticket = ticket_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Ticket{} = ticket} = Plan.update_ticket(ticket, update_attrs)

      assert ticket.title == "some updated title"
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      ticket = ticket_fixture()
      assert {:error, %Ecto.Changeset{}} = Plan.update_ticket(ticket, %{title: nil})
      assert Plan.get_ticket!(ticket.id) == ticket
    end

    test "change_ticket/1 returns a ticket changeset" do
      ticket = ticket_fixture()
      assert %Ecto.Changeset{} = Plan.change_ticket(ticket)
    end
  end
end
