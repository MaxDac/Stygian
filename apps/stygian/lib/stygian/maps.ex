defmodule Stygian.Maps do
  @moduledoc """
  The Maps context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Stygian.Repo

  alias Stygian.Characters.Character
  alias Stygian.Characters.CharacterSkill
  alias Stygian.Maps.Map, as: LandMap
  alias Stygian.Maps.PrivateMapCharacter

  @default_limit_in_hour 2
  @private_map_timeout_in_hour 3

  @doc """
  Returns the list of maps.

  ## Examples

      iex> list_maps()
      [%Map{}, ...]

  """
  def list_maps do
    Repo.all(LandMap)
  end

  @doc """
  Returns the list of the main maps, the ones that does not have any parent.
  """
  @spec list_parent_maps() :: list(LandMap.t())
  def list_parent_maps do
    LandMap
    |> from()
    |> where([m], is_nil(m.parent_id))
    |> Repo.all()
  end

  @doc """
  Returns the list of the maps whose parent is the map given in input.
  """
  @spec list_child_maps(LandMap.t()) :: list(LandMap.t())
  def list_child_maps(%{id: parent_id}) do
    LandMap
    |> from()
    |> where([m], m.parent_id == ^parent_id)
    |> Repo.all()
  end

  @doc """
  Gets a single map.

  Raises `Ecto.NoResultsError` if the Map does not exist.

  ## Examples

      iex> get_map!(123)
      %Map{}

      iex> get_map!(456)
      ** (Ecto.NoResultsError)

  """
  def get_map!(id), do: Repo.get!(LandMap, id)

  @doc """
  Gets a single map, or nil if it does not exist.
  """
  def get_map(id), do: Repo.get(LandMap, id)

  @doc """
  Gets a single map by name, or nil if it doesn't find it.
  """
  def get_map_by_name(name), do: Repo.get_by(LandMap, name: name)

  @doc """
  Gets a map with the preloaded children.
  """
  @spec get_map_with_children(integer()) :: LandMap.t()
  def get_map_with_children(map_id) do
    LandMap
    |> from()
    |> where([p], p.id == ^map_id)
    |> preload(:children)
    |> Repo.one()
  end

  @doc """
  Creates a map.

  ## Examples

      iex> create_map(%{field: value})
      {:ok, %Map{}}

      iex> create_map(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_map(attrs \\ %{}) do
    %LandMap{}
    |> LandMap.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a map.

  ## Examples

      iex> update_map(map, %{field: new_value})
      {:ok, %Map{}}

      iex> update_map(map, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_map(%LandMap{} = map, attrs) do
    map
    |> LandMap.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a map.

  ## Examples

      iex> delete_map(map)
      {:ok, %Map{}}

      iex> delete_map(map)
      {:error, %Ecto.Changeset{}}

  """
  def delete_map(%LandMap{} = map) do
    Repo.delete(map)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking map changes.

  ## Examples

      iex> change_map(map)
      %Ecto.Changeset{data: %Map{}}

  """
  def change_map(%LandMap{} = map, attrs \\ %{}) do
    LandMap.changeset(map, attrs)
  end

  alias Stygian.Maps.Chat

  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats do
    Repo.all(Chat)
  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat!(id), do: Repo.get!(Chat, id)

  @doc """
  Lists all the chat entries belonging to a map after the given time.
  """
  @spec list_map_chats(non_neg_integer(), NaiveDateTime.t() | nil) :: list(Chat.t())
  def list_map_chats(map_id, limit \\ nil)

  def list_map_chats(map_id, nil) do
    default_limit =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(-1 * @default_limit_in_hour, :hour)

    list_map_chats(map_id, default_limit)
  end

  def list_map_chats(map_id, limit) do
    Chat
    |> from()
    |> where([c], c.map_id == ^map_id and c.updated_at >= ^limit)
    |> order_by([c], asc: c.updated_at)
    |> preload(:character)
    |> Repo.all()
  end

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(attrs \\ %{}) do
    chat =
      %Chat{}
      |> Chat.changeset(attrs)
      |> Repo.insert()

    case chat do
      {:ok, chat} -> {:ok, Repo.preload(chat, :character)}
      error -> error
    end
  end

  @type chat_entry_request() :: %{
          character: Character.t(),
          map: LandMap.t(),
          attribute: CharacterSkill.t(),
          skill: CharacterSkill.t(),
          modifier: integer(),
          difficulty: pos_integer()
        }

  @doc """
  Creates a chat entry for a dice throw.

  The `dice_thrower` function is a function that takes the number of faces of the dice and returns the result of the throw.
  It has been abstracted for test purposes.
  """
  @spec create_dice_throw_chat_entry(request :: chat_entry_request(), dice_thrower :: function()) ::
          {:ok, Chat.t()} | {:error, Ecto.Changeset.t()}
  def create_dice_throw_chat_entry(
        %{
          character: %{id: character_id},
          map: %{id: map_id},
          attribute: %{value: attribute_value},
          skill: %{value: skill_value},
          modifier: modifier,
          difficulty: difficulty
        } = request,
        dice_thrower
      ) do
    chat_explanation = get_chat_explanation(request)
    base = attribute_value + skill_value + modifier
    dice_result = dice_thrower.(20)

    result = base + dice_result

    text =
      case {dice_result, result} do
        {1, _} ->
          "ottenendo un fallimento critico"

        {20, _} ->
          "ottenendo un successo critico"

        {_, n} when n < difficulty ->
          "ottenendo un fallimento"

        _ ->
          "ottenendo un successo"
      end

    chat_text = "#{chat_explanation} #{text} (#{base} + #{dice_result})."

    create_chat(%{
      character_id: character_id,
      map_id: map_id,
      text: chat_text,
      type: :dices
    })
  end

  defp get_chat_explanation(%{
         attribute: %{skill: %{name: attribute_name}},
         skill: %{skill: %{name: skill_name}},
         modifier: modifier,
         difficulty: difficulty
       }) do
    modifier_text =
      case modifier do
        n when n > 0 -> " + #{n}"
        n when n < 0 -> " - #{abs(n)}"
        _ -> ""
      end

    "Ha effettuato un tiro di #{attribute_name} + #{skill_name}#{modifier_text} con Diff. #{difficulty}"
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat(%Chat{} = chat) do
    Repo.delete(chat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat changes.

  ## Examples

      iex> change_chat(chat)
      %Ecto.Changeset{data: %Chat{}}

  """
  def change_chat(%Chat{} = chat, attrs \\ %{}) do
    Chat.changeset(chat, attrs)
  end

  @doc """
  Lists all the private rooms, specifying their status.
  """
  @spec list_private_rooms() :: list(PrivateMapCharacter.t())
  def list_private_rooms do
    limit = 
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(@private_map_timeout_in_hour * -1, :hour)

    LandMap
    |> from()
    |> where([m], m.private and m.inserted_at >= ^limit)
    |> preload(:hosts)
    |> Repo.all()
    |> Enum.map(fn 
      %{hosts: []} = map -> 
        Map.put(map, :status, :free)

      map ->
        Map.put(map, :status, :occupied)
    end)
  end

  @doc """
  Lists all the characters allowed into a private map.
  """
  @spec list_private_map_characters(map_id :: non_neg_integer()) :: list(PrivateMapCharacters.t())
  def list_private_map_characters(map_id) do
    PrivateMapCharacter
    |> from()
    |> where([p], p.map_id == ^map_id)
    |> Repo.all()
  end

  @doc """
  Creates a new private entry for a character.
  """
  @spec create_private_map_character(map()) :: 
    {:ok, PrivateMapCharacter.t()} | {:error, Changeset.t()}
  def create_private_map_character(attrs \\ %{}) do
    %PrivateMapCharacter{}
    |> PrivateMapCharacter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Books a room. The room must have an host, and a list of character.
  """
  @spec book_private_room(
                  map_id :: non_neg_integer(),
                  host_id :: non_neg_integer(),
                  character_ids :: list(non_neg_integer())) ::
    :ok | {:error, Changeset.t()}
  def book_private_room(map_id, host_id, character_ids)

  def book_private_room(_, _, []), do: {:error, Changeset.add_error(%Changeset{}, :character_ids, "Devi specificare almeno un altro personaggio")}

  def book_private_room(_, host_id, _) when is_nil(host_id), do: {:error, Changeset.add_error(%Changeset{}, :host_id, "Devi specificare l'ospite")}

  def book_private_room(map_id, host_id, character_ids) do
    if is_private(map_id) do
      host_changeset =
        %PrivateMapCharacter{}
        |> PrivateMapCharacter.changeset(%{map_id: map_id, character_id: host_id, host: true})

      multi = 
        Ecto.Multi.new()
        |> Ecto.Multi.insert(host_id, host_changeset)

      multi =
        Enum.reduce(character_ids, multi, fn id, m ->
          changeset =
            %PrivateMapCharacter{}
            |> PrivateMapCharacter.changeset(%{map_id: map_id, character_id: id, host: true})

          m
          |> Ecto.Multi.insert(id, changeset)
        end)

      with {:ok, _} <- Repo.transaction(multi) do
        :ok
      end
    else
      {:error, Changeset.add_error(%Changeset{}, :map_id, "La mappa non e' una stanza privata.")}
    end
  end

  defp is_private(map_id) do
    case get_map(map_id) do
      %{private: true} -> true
      _ -> false
    end
  end

  @doc """
  Adds another guest to the private map. The map must be booked before inviting other characters.
  """
  @spec add_character_guest(map_id :: non_neg_integer(), character_id :: non_neg_integer()) ::
    {:ok, PrivateMapCharacter.t()} | {:error, Changeset.t()}
  def add_character_guest(map_id, character_id) do
    case list_private_map_characters(map_id) do
      [] -> 
        {:error, Changeset.add_error(%Changeset{}, :map_id, "La mappa e' attualmente libera, non puoi aggiungere un ospite senza prenotarla.")}

      _ ->
        %PrivateMapCharacter{}
        |> PrivateMapCharacter.changeset(%{map_id: map_id, character_id: character_id})
        |> Repo.insert()
    end
  end
end
