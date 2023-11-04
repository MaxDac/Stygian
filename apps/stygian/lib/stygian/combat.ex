defmodule Stygian.Combat do
  @moduledoc """
  The Combat context.
  """

  import Ecto.Query, warn: false
  alias Stygian.Repo

  alias Stygian.Combat.WeaponType

  @doc """
  Returns the list of weapon_types.

  ## Examples

      iex> list_weapon_types()
      [%WeaponType{}, ...]

  """
  def list_weapon_types do
    Repo.all(WeaponType)
  end

  @doc """
  Gets a single weapon_type.

  Raises `Ecto.NoResultsError` if the Weapon type does not exist.

  ## Examples

      iex> get_weapon_type!(123)
      %WeaponType{}

      iex> get_weapon_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_weapon_type!(id), do: Repo.get!(WeaponType, id)

  @doc """
  Gets the weapon type by its name.
  """
  @spec get_weapon_type_by_name(String.t()) :: WeaponType.t() | nil
  def get_weapon_type_by_name(name) do
    Repo.get_by(WeaponType, name: name)
  end

  @doc """
  Creates a weapon_type.

  ## Examples

      iex> create_weapon_type(%{field: value})
      {:ok, %WeaponType{}}

      iex> create_weapon_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_weapon_type(attrs \\ %{}) do
    %WeaponType{}
    |> WeaponType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a weapon_type.

  ## Examples

      iex> update_weapon_type(weapon_type, %{field: new_value})
      {:ok, %WeaponType{}}

      iex> update_weapon_type(weapon_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_weapon_type(%WeaponType{} = weapon_type, attrs) do
    weapon_type
    |> WeaponType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a weapon_type.

  ## Examples

      iex> delete_weapon_type(weapon_type)
      {:ok, %WeaponType{}}

      iex> delete_weapon_type(weapon_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_weapon_type(%WeaponType{} = weapon_type) do
    Repo.delete(weapon_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking weapon_type changes.

  ## Examples

      iex> change_weapon_type(weapon_type)
      %Ecto.Changeset{data: %WeaponType{}}

  """
  def change_weapon_type(%WeaponType{} = weapon_type, attrs \\ %{}) do
    WeaponType.changeset(weapon_type, attrs)
  end

  alias Stygian.Combat.Action

  @doc """
  Returns the list of combat_actions.

  ## Examples

      iex> list_combat_actions()
      [%Action{}, ...]

  """
  def list_combat_actions do
    Repo.all(Action)
  end

  @doc """
  Gets a single action.

  Raises `Ecto.NoResultsError` if the Action does not exist.

  ## Examples

      iex> get_action!(123)
      %Action{}

      iex> get_action!(456)
      ** (Ecto.NoResultsError)

  """
  def get_action!(id), do: Repo.get!(Action, id)

  @doc """
  Gets the action by its name.
  """
  @spec get_action_by_name(String.t()) :: Action.t() | nil
  def get_action_by_name(name) do
    Repo.get_by(Action, name: name)
  end

  @doc """
  Creates a action.

  ## Examples

      iex> create_action(%{field: value})
      {:ok, %Action{}}

      iex> create_action(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_action(attrs \\ %{}) do
    %Action{}
    |> Action.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a action.

  ## Examples

      iex> update_action(action, %{field: new_value})
      {:ok, %Action{}}

      iex> update_action(action, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_action(%Action{} = action, attrs) do
    action
    |> Action.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a action.

  ## Examples

      iex> delete_action(action)
      {:ok, %Action{}}

      iex> delete_action(action)
      {:error, %Ecto.Changeset{}}

  """
  def delete_action(%Action{} = action) do
    Repo.delete(action)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking action changes.

  ## Examples

      iex> change_action(action)
      %Ecto.Changeset{data: %Action{}}

  """
  def change_action(%Action{} = action, attrs \\ %{}) do
    Action.changeset(action, attrs)
  end
end
