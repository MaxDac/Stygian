defmodule Stygian.Maps.Chat do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Stygian.Characters.Character
  alias Stygian.Combat.ChatAction
  alias Stygian.Maps.Map

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          text: String.t(),
          type:
            :text | :master | :dices | :failed_dices | :special | :confirm | :action_result | :off,
          character_id: non_neg_integer(),
          map_id: non_neg_integer(),
          chat_action_id: non_neg_integer(),
          character: Character.t(),
          map: Map.t(),
          chat_action: ChatAction.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "chats" do
    field :text, :string

    field :type, Ecto.Enum,
      values: [:text, :master, :dices, :failed_dices, :special, :confirm, :action_result, :off]

    belongs_to :character, Character
    belongs_to :map, Map
    belongs_to :chat_action, ChatAction

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

  @doc false
  def chat_action_changeset(chat, attrs) do
    chat
    |> cast(attrs, [:text, :type, :character_id, :map_id, :chat_action_id])
    |> validate_required([:type, :character_id, :map_id, :chat_action_id])
    |> foreign_key_constraint(:character_id)
    |> foreign_key_constraint(:map_id)
    |> foreign_key_constraint(:chat_action_id)
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
      min: 150,
      message: "La lunghezza minima della frase deve essere di 150 caratteri"
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
