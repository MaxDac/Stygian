defmodule Stygian.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Accounts.User

  @type t() :: %__MODULE__{
          admin_notes: String.t(),
          avatar: String.t(),
          biography: String.t(),
          cigs: integer(),
          description: String.t(),
          experience: integer(),
          health: integer(),
          name: String.t(),
          notes: String.t(),
          sanity: integer(),
          step: integer(),
          user_id: integer(),
          user: User.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "characters" do
    field :admin_notes, :string
    field :avatar, :string
    field :biography, :string
    field :cigs, :integer
    field :description, :string
    field :experience, :integer
    field :health, :integer
    field :name, :string
    field :notes, :string
    field :sanity, :integer
    field :step, :integer

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [
      :name,
      :avatar,
      :biography,
      :description,
      :cigs,
      :notes,
      :admin_notes,
      :experience,
      :health,
      :sanity,
      :step,
      :user_id
    ])
    |> validate_required([
      :name,
      :avatar,
      :biography,
      :description,
      :cigs,
      :notes,
      :admin_notes,
      :experience,
      :health,
      :sanity,
      :step,
      :user_id
    ])
    |> foreign_key_constraint(:user_id, name: :characters_user_id_fkey)
    |> unique_constraint(:name)
  end
end
