defmodule Stygian.Organisations.Organisation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organisations" do
    field :name, :string
    field :description, :string
    field :image, :string
    field :base_salary, :integer

    timestamps()
  end

  @doc false
  def changeset(organisation, attrs) do
    organisation
    |> cast(attrs, [:name, :description, :base_salary, :image])
    |> validate_required([:name, :base_salary])
  end
end
