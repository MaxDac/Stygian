defmodule Stygian.Maps do
  @moduledoc """
  The Maps context.
  """

  import Ecto.Query, warn: false
  alias Stygian.Repo

  alias Stygian.Maps.Map

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
end
