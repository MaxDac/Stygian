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
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "objects" do
    field :description, :string
    field :image_url, :string
    field :name, :string
    field :usages, :integer

    timestamps()
  end

  @doc false
  def changeset(object, attrs) do
    object
    |> cast(attrs, [:name, :description, :image_url, :usages])
    |> validate_required([:name, :description, :image_url, :usages])
  end
end
