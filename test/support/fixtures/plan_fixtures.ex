defmodule Points.PlanFixtures do
  @moduledoc false

  alias Points.Plan

  def unique_project_name(rando \\ System.unique_integer()), do: "some project #{rando}"

  def plan_project_fixture do
    %{id: id} = Points.ReportFixtures.project_fixture()
    Plan.get_project!(id)
  end

  def ticket_fixture(project \\ plan_project_fixture(), attrs \\ %{}) do
    {:ok, ticket} =
      Plan.create_ticket(
        project,
        Enum.into(attrs, %{
          title: unique_project_name(),
          description: "A valid description",
          extra_info: "Valid extra info"
        })
      )

    ticket
  end
end
