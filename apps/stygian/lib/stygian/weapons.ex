defmodule Stygian.Weapons do
  @moduledoc """
  The Weapons context.
  """

  import Ecto.Query, warn: false
  alias Stygian.Repo

  alias Stygian.Weapons.Weapon

  @doc """
  Returns the list of weapons.
  
  ## Examples
  
      iex> list_weapons()
      [%Weapon{}, ...]
  
  """
  def list_weapons do
    Repo.all(Weapon)
  end

  @doc """
  Gets a single weapon.
  
  Raises `Ecto.NoResultsError` if the Weapon does not exist.
  
  ## Examples
  
      iex> get_weapon!(123)
      %Weapon{}
  
      iex> get_weapon!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_weapon!(id), do: Repo.get!(Weapon, id)

  @doc """
  Creates a weapon.
  
  ## Examples
  
      iex> create_weapon(%{field: value})
      {:ok, %Weapon{}}
  
      iex> create_weapon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_weapon(attrs \\ %{}) do
    %Weapon{}
    |> Weapon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a weapon.
  
  ## Examples
  
      iex> update_weapon(weapon, %{field: new_value})
      {:ok, %Weapon{}}
  
      iex> update_weapon(weapon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_weapon(%Weapon{} = weapon, attrs) do
    weapon
    |> Weapon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a weapon.
  
  ## Examples
  
      iex> delete_weapon(weapon)
      {:ok, %Weapon{}}
  
      iex> delete_weapon(weapon)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_weapon(%Weapon{} = weapon) do
    Repo.delete(weapon)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking weapon changes.
  
  ## Examples
  
      iex> change_weapon(weapon)
      %Ecto.Changeset{data: %Weapon{}}
  
  """
  def change_weapon(%Weapon{} = weapon, attrs \\ %{}) do
    Weapon.changeset(weapon, attrs)
  end

  alias Stygian.Characters.Character

  @doc """
  Lists all the weapons belonging to a character.
  """
  @spec get_character_weapons(character_id :: non_neg_integer()) :: list(Weapon.t())
  def get_character_weapons(character_id) do
    character =
      Character
      |> preload(:weapons)
      |> Repo.get(character_id)

    if not is_nil(character) do
      character.weapons
    else
      []
    end
  end
end
