defmodule Stygian.Maps do
  @moduledoc """
  The Maps context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Stygian.Repo

  alias Stygian.Maps.Map, as: LandMap
  alias Stygian.Maps.MapChatsSelectionForm
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
  Shows the logs of the map chats for the given filters.
  """
  @spec list_map_chats_logs(filters :: MapChatsSelectionForm.t()) :: list(Chat.t())
  def list_map_chats_logs(%{
        map_id: map_id,
        date_from: date_from,
        date_to: date_to
      }) do
    Chat
    |> from()
    |> where([c], c.map_id == ^map_id and c.updated_at >= ^date_from and c.updated_at <= ^date_to)
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

  @doc """
  Creates a chat allowing a custom `inserted_at` field 
  """
  def create_chat_test(attrs \\ %{}) do
    %Chat{}
    |> Chat.test_changeset(attrs)
    |> Repo.insert()
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

  defp get_current_valid_limit do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(@private_map_timeout_in_hour * -1, :hour)
  end

  @doc """
  Lists all the private rooms, specifying their status.
  """
  @spec list_private_rooms() :: list(PrivateMapCharacter.t())
  def list_private_rooms do
    limit = get_current_valid_limit()

    LandMap
    |> from()
    |> where([m], m.private)
    |> preload(:hosts)
    |> Repo.all()
    |> Enum.map(fn
      %{hosts: []} = map ->
        Map.put(map, :status, :free)

      %{hosts: hosts} = map ->
        status =
          if Enum.any?(hosts, &(&1.inserted_at >= limit)) do
            :occupied
          else
            :free
          end

        Map.put(map, :status, status)
    end)
  end

  @doc """
  Lists all the characters allowed into a private map.
  """
  @spec list_private_map_characters(map_id :: non_neg_integer()) :: list(PrivateMapCharacter.t())
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
          character_ids :: list(non_neg_integer())
        ) ::
          :ok | {:error, Changeset.t()}
  def book_private_room(map_id, host_id, character_ids)

  def book_private_room(_, _, []),
    do:
      {:error,
       Changeset.add_error(
         %Changeset{},
         :character_ids,
         "Devi specificare almeno un altro personaggio"
       )}

  def book_private_room(_, host_id, _) when is_nil(host_id),
    do: {:error, Changeset.add_error(%Changeset{}, :host_id, "Devi specificare l'ospite")}

  def book_private_room(map_id, host_id, character_ids) do
    if is_private(map_id) && not character_is_already_host?(host_id) do
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
            |> PrivateMapCharacter.changeset(%{map_id: map_id, character_id: id, host: false})

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
  Determines whether the character is hosting another private room.
  """
  @spec character_is_already_host?(character_id :: non_neg_integer()) :: boolean()
  def character_is_already_host?(character_id) do
    limit = get_current_valid_limit()

    PrivateMapCharacter
    |> where([p], p.character_id == ^character_id and p.host and p.inserted_at >= ^limit)
    |> Repo.exists?()
  end

  @doc """
  Determines whether the character is host or has been invited in the private room.
  """
  @spec is_character_allowed?(map_id :: non_neg_integer(), character_id :: non_neg_integer()) ::
          boolean()
  def is_character_allowed?(map_id, character_id) do
    limit = get_current_valid_limit()

    PrivateMapCharacter
    |> where(
      [p],
      p.map_id == ^map_id and p.character_id == ^character_id and p.inserted_at >= ^limit
    )
    |> Repo.exists?()
  end

  @doc """
  Adds another guest to the private map. The map must be booked before inviting other characters.
  """
  @spec add_character_guest(map_id :: non_neg_integer(), character_id :: non_neg_integer()) ::
          {:ok, PrivateMapCharacter.t()} | {:error, Changeset.t()}
  def add_character_guest(map_id, character_id) do
    case list_private_map_characters(map_id) do
      [] ->
        {:error,
         Changeset.add_error(
           %Changeset{},
           :map_id,
           "La mappa e' attualmente libera, non puoi aggiungere un ospite senza prenotarla."
         )}

      _ ->
        %PrivateMapCharacter{}
        |> PrivateMapCharacter.changeset(%{map_id: map_id, character_id: character_id})
        |> Repo.insert()
    end
  end
end
