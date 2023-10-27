defmodule Stygian.Maps.Chat do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Characters.Character
  alias Stygian.Maps.Map

  @type t() :: %__MODULE__{
          id: integer(),
          text: String.t(),
          type: :text | :master | :dices | :failed_dices | :special | :off,
          character_id: integer(),
          character: Character.t(),
          map_id: integer(),
          map: Map.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "chats" do
    field :text, :string
    field :type, Ecto.Enum, values: [:text, :master, :dices, :failed_dices, :special, :off]
    belongs_to :character, Character
    belongs_to :map, Map

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:text, :type, :character_id, :map_id])
    |> validate_chat_text_not_null()
    |> validate_chat_text_max_length()
    |> validate_chat_text_min_length(attrs)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:map_id)
    |> validate_required([:type, :character_id, :map_id])
  end

  defp validate_chat_text_not_null(changeset) do
    validate_required(changeset, [:text], message: "La frase non può essere vuota")
  end

  defp validate_chat_text_max_length(changeset) do
    changeset
    |> validate_length(:text,
      max: 1200,
      message: "La lunghezza massima della frase deve essere di 1200 caratteri"
    )
  end

  defp validate_chat_text_min_length(changeset, %{"type" => :text}) do
    changeset
    |> validate_length(:text,
      min: 200,
      message: "La lunghezza minima della frase deve essere di 200 caratteri"
    )
  end

  defp validate_chat_text_min_length(changeset, _), do: changeset

  @doc false
  def test_changeset(chat, attrs) do
    chat
    |> cast(attrs, [:text, :type, :character_id, :map_id, :inserted_at, :updated_at])
    |> validate_chat_text_not_null()
    |> validate_chat_text_max_length()
    |> validate_chat_text_min_length(attrs)
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:map_id)
    |> validate_required([:type, :character_id, :map_id])
  end
end
