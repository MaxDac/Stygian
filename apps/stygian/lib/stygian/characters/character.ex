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
          age: :young | :adult | :old,
          sin: String.t(),
          npc: boolean(),
          rest_timer: NaiveDateTime.t(),
          last_cigs_effect: NaiveDateTime.t(),
          research_points: integer(),
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
    field :age, Ecto.Enum, values: [:young, :adult, :old]
    field :sin, :string
    field :npc, :boolean
    field :rest_timer, :naive_datetime
    field :last_cigs_effect, :naive_datetime
    field :research_points, :integer, default: 0

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
      :age,
      :sin,
      :lost_health,
      :lost_sanity,
      :npc
    ])
    |> validate_required([
      :name,
      :avatar,
      :user_id,
      :age,
      :sin
    ])
    |> validate_length(:name, min: 5, max: 50)
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
    |> cast(attrs, [:user_id, :name, :avatar, :small_avatar, :npc, :age, :sin])
    |> validate_required([:user_id, :name, :avatar, :npc, :age, :sin])
    |> foreign_key_constraint(:user_id, name: :characters_user_id_fkey)
  end

  def change_cigs_changeset(character, attrs) do
    character
    |> cast(attrs, [:cigs])
    |> validate_required([:cigs])
  end

  def change_experience_changeset(character, attrs) do
    character
    |> cast(attrs, [:experience])
    |> validate_required([:experience])
  end

  def change_health_and_sanity_changeset(character, attrs) do
    character
    |> cast(attrs, [:lost_health, :lost_sanity, :last_cigs_effect])
    |> validate_required([:lost_health, :lost_sanity])
  end

  def change_rest_stats(character, attrs) do
    character
    |> cast(attrs, [:cigs, :lost_health, :lost_sanity, :research_points, :rest_timer])
    |> validate_required([:cigs, :lost_health, :lost_sanity, :research_points, :rest_timer])
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
      :age,
      :sin,
      :npc,
      :rest_timer,
      :last_cigs_effect,
      :research_points,
      :user_id
    ])
    |> validate_required([
      :name,
      :avatar,
      :cigs,
      :experience,
      :health,
      :sanity,
      :step,
      :age,
      :user_id
    ])
    |> foreign_key_constraint(:user_id, name: :characters_user_id_fkey)
    |> unique_constraint(:name)
  end
end
