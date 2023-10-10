defmodule Stygian.Objects.Object do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          name: String.t(),
          description: String.t(),
          image_url: String.t(),
          usages: integer(),
          health: integer(),
          sanity: integer(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "objects" do
    field :description, :string
    field :image_url, :string
    field :name, :string
    field :usages, :integer
    field :health, :integer
    field :sanity, :integer

    timestamps()
  end

  @doc false
  def changeset(object, attrs) do
    object
    |> cast(attrs, [:name, :description, :image_url, :usages, :sanity, :health])
    |> validate_required([:name, :description, :usages])
    |> unique_constraint(:name, name: :objects_name_index)
  end
end
