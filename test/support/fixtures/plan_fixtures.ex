defmodule Points.PlanFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Points.Plan` context.
  """

  @doc """
  Generate a project.
  """

  alias Points.Plan
  alias Points.Plan.Project

  def unique_project_name(rando \\ System.unique_integer()), do: "some project #{rando}"
  def unique_sub_project_name(rando \\ System.unique_integer()), do: "some sub-project #{rando}"

  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        title: unique_project_name()
      })
      |> Plan.create_project()

    project
  end

  def sub_project_fixture(attrs \\ %{})

  def sub_project_fixture(%{parent: %Project{} = parent} = attrs) do
    merged_attrs =
      attrs
      |> Enum.into(%{
        title: unique_sub_project_name()
      })

    {:ok, sub_project} = Plan.create_sub_project(parent, merged_attrs)
    sub_project
  end

  def sub_project_fixture(%{parent: parent_attrs} = attrs) do
    merged_attrs =
      attrs
      |> Enum.into(%{
        title: unique_sub_project_name()
      })

    {:ok, sub_project} = Plan.create_sub_project(parent_attrs, merged_attrs)
    sub_project
  end

  def sub_project_fixture(attrs) do
    merged_attrs =
      attrs
      |> Enum.into(%{
        title: unique_sub_project_name()
      })

    {:ok, project} = Plan.create_sub_project(project_fixture(), merged_attrs)
    project
  end
end
