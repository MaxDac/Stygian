defmodule Stygian.Objects.Object do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

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
