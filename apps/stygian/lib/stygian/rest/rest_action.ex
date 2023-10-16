defmodule Stygian.Rest.RestAction do
  @moduledoc """
  Rest action schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t() :: %__MODULE__{
          id: integer(),
          name: String.t(),
          description: String.t(),
          health: integer(),
          sanity: integer(),
          research_points: integer(),
          slots: integer(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "rest_actions" do
    field :name, :string
    field :description, :string
    field :health, :integer
    field :sanity, :integer
    field :research_points, :integer
    field :slots, :integer

    timestamps()
  end

  @doc false
  def changeset(rest_action, attrs) do
    rest_action
    |> cast(attrs, [:name, :description, :health, :sanity, :research_points, :slots])
    |> validate_required([:name, :description, :health, :sanity, :research_points, :slots])
    |> unique_constraint(:name, name: :unique_rest_action_name)
  end
end
