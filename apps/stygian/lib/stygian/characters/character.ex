defmodule Stygian.Characters.Character do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Accounts.User

  @type t() :: %__MODULE__{
          admin_notes: String.t(),
          avatar: String.t(),
          small_avatar: String.t(),
          biography: String.t(),
          cigs: integer(),
          description: String.t(),
          custom_sheet: String.t(),
          experience: integer(),
          health: integer(),
          lost_health: integer(),
          name: String.t(),
          notes: String.t(),
          sanity: integer(),
          lost_sanity: integer(),
          step: integer(),
          npc: boolean(),
          user_id: integer(),
          user: User.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "characters" do
    field :admin_notes, :string
    field :avatar, :string
    field :small_avatar, :string
    field :biography, :string
    field :cigs, :integer
    field :description, :string
    field :custom_sheet, :string
    field :experience, :integer
    field :health, :integer
    field :lost_health, :integer
    field :name, :string
    field :notes, :string
    field :sanity, :integer
    field :lost_sanity, :integer
    field :step, :integer
    field :npc, :boolean

    belongs_to :user, User

    timestamps()
  end

  def name_avatar_changeset(character, attrs) do
    character
    |> cast(attrs, [
      :name,
      :avatar,
      :user_id,
      :step,
      :lost_health,
      :lost_sanity,
      :npc
    ])
    |> validate_required([
      :name,
      :avatar,
      :user_id
    ])
    |> validate_length(:name, min: 10, max: 50)
    |> foreign_key_constraint(:user_id, name: :characters_user_id_fkey)
    |> unique_constraint(:name)
  end

  def complete_character_changeset(character, attrs) do
    character
    |> cast(attrs, [:step, :health, :sanity, :experience, :cigs])
    |> validate_required([:step, :health, :sanity, :experience, :cigs])
  end

  def modify_character_notes_changeset(character, attrs) do
    character
    |> cast(attrs, [:avatar, :small_avatar, :biography, :description, :notes, :custom_sheet])
    |> validate_required([:avatar, :biography, :description])
  end

  def npc_changeset(character, attrs) do
    character
    |> cast(attrs, [:user_id, :name, :avatar, :small_avatar])
    |> validate_required([:user_id, :name, :avatar])
    |> foreign_key_constraint(:user_id, name: :characters_user_id_fkey)
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [
      :name,
      :avatar,
      :small_avatar,
      :biography,
      :description,
      :custom_sheet,
      :cigs,
      :notes,
      :admin_notes,
      :experience,
      :health,
      :lost_health,
      :sanity,
      :lost_sanity,
      :step,
      :npc,
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
