defmodule Stygian.Rest do
  @moduledoc """
  The Rest context.
  """

  import Ecto.Query, warn: false
  alias Stygian.Repo

  alias Stygian.Rest.RestAction

  @doc """
  Returns the list of rest_actions.

  ## Examples

      iex> list_rest_actions()
      [%RestAction{}, ...]

  """
  def list_rest_actions do
    Repo.all(RestAction)
  end

  @doc """
  Gets a single rest_action.

  Raises `Ecto.NoResultsError` if the Rest action does not exist.

  ## Examples

      iex> get_rest_action!(123)
      %RestAction{}

      iex> get_rest_action!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rest_action!(id), do: Repo.get!(RestAction, id)

  @doc """
  Gets a rest action by its name.
  """
  @spec get_rest_action!(name :: String.t()) :: RestAction.t()
  def get_rest_action_by_name(name) do
    RestAction
    |> from()
    |> where([r], r.name == ^name)
    |> Repo.one()
  end

  @doc """
  Creates a rest_action.

  ## Examples

      iex> create_rest_action(%{field: value})
      {:ok, %RestAction{}}

      iex> create_rest_action(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rest_action(attrs \\ %{}) do
    %RestAction{}
    |> RestAction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rest_action.

  ## Examples

      iex> update_rest_action(rest_action, %{field: new_value})
      {:ok, %RestAction{}}

      iex> update_rest_action(rest_action, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rest_action(%RestAction{} = rest_action, attrs) do
    rest_action
    |> RestAction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rest_action.

  ## Examples

      iex> delete_rest_action(rest_action)
      {:ok, %RestAction{}}

      iex> delete_rest_action(rest_action)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rest_action(%RestAction{} = rest_action) do
    Repo.delete(rest_action)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rest_action changes.

  ## Examples

      iex> change_rest_action(rest_action)
      %Ecto.Changeset{data: %RestAction{}}

  """
  def change_rest_action(%RestAction{} = rest_action, attrs \\ %{}) do
    RestAction.changeset(rest_action, attrs)
  end
end
