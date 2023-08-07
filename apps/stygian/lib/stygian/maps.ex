defmodule Stygian.Maps do
  @moduledoc """
  The Maps context.
  """

  import Ecto.Query, warn: false
  alias Stygian.Repo

  alias Stygian.Maps.Map

  @default_limit_in_hour 2

  @doc """
  Returns the list of maps.

  ## Examples

      iex> list_maps()
      [%Map{}, ...]

  """
  def list_maps do
    Repo.all(Map)
  end

  @doc """
  Returns the list of the main maps, the ones that does not have any parent.
  """
  @spec list_parent_maps() :: list(Map.t())
  def list_parent_maps do
    Map
    |> from()
    |> where([m], is_nil(m.parent_id))
    |> Repo.all()
  end

  @doc """
  Returns the list of the maps whose parent is the map given in input.
  """
  @spec list_child_maps(Map.t()) :: list(Map.t())
  def list_child_maps(%{id: parent_id}) do
    Map
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
  def get_map!(id), do: Repo.get!(Map, id)

  @doc """
  Gets a single map, or nil if it does not exist.
  """
  def get_map(id), do: Repo.get(Map, id)

  @doc """
  Gets a single map by name, or nil if it doesn't find it.
  """
  def get_map_by_name(name), do: Repo.get_by(Map, name: name)

  @doc """
  Gets a map with the preloaded children.
  """
  @spec get_map_with_children(integer()) :: Map.t()
  def get_map_with_children(map_id) do
    Map
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
    %Map{}
    |> Map.changeset(attrs)
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
  def update_map(%Map{} = map, attrs) do
    map
    |> Map.changeset(attrs)
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
  def delete_map(%Map{} = map) do
    Repo.delete(map)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking map changes.

  ## Examples

      iex> change_map(map)
      %Ecto.Changeset{data: %Map{}}

  """
  def change_map(%Map{} = map, attrs \\ %{}) do
    Map.changeset(map, attrs)
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
end
