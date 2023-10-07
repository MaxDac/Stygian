defmodule Stygian.Organisations.Organisation do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
    name: String.t(),
    description: String.t(),
    image: String.t(),
    base_salary: non_neg_integer(),

    inserted_at: NaiveDateTime.t(),
    updated_at: NaiveDateTime.t()
  }

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
    |> unique_constraint(:name, name: :organisations_name_index)
  end
end
