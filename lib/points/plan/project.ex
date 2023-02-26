defmodule Points.Plan.Project do
  @moduledoc """
  In the report tickets can belong to either projects or sub projects however
  in the Plan context they are both represented by this module.
  """
  use Ecto.Schema
  alias Points.Plan.Ticket

  schema "projects" do
    field :parent_id, :integer

    has_many :tickets, Ticket
  end
end
