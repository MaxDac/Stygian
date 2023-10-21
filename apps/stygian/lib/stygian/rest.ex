defmodule Stygian.Rest do
  @moduledoc """
  The Rest context.
  """

  import Ecto.Query, warn: false

  alias Stygian.Repo

  alias Stygian.Characters.Character
  alias Stygian.Rest.RestAction

  @rest_limit_hours 24
  @rest_sanity_recovery 5
  @rest_cost 5
  @complex_rest_cost 20


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

  @doc """
  Perform the resting of the character.
  This operation restores some of the characters characteristics, and sets the new timer.
  It can be performed only once every 24 hours.
  """
  @spec rest_character(character :: Character.t(), rest_cost :: non_neg_integer()) ::
          {:ok, Character.t()} | {:error, String.t()} | {:error, Changeset.t()}
  def rest_character(character, rest_cost \\ @rest_cost)

  def rest_character(%{cigs: cigs}, rest_cost) when cigs < rest_cost,
    do: {:error, "Non hai abbastanza sigarette per poter pagare l'albergo."}

  def rest_character(character, rest_cost) do
    limit =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.add(@rest_limit_hours * -1, :hour)

    case character.rest_timer do
      nil ->
        apply_rest_effect(character, rest_cost)

      rest_timer ->
        if NaiveDateTime.compare(rest_timer, limit) == :lt do
          apply_rest_effect(character, rest_cost)
        else
          {:error, "Non puoi ancora far riposare il personaggio."}
        end
    end
  end

  defp apply_rest_effect(%{cigs: cigs} = _character, rest_cost) when cigs < rest_cost,
    do: {:error, "Non hai abbastanza sigarette per poter pagare l'albergo."}

  defp apply_rest_effect(%{lost_sanity: lost_sanity, cigs: cigs} = character, rest_cost) do
    attrs = %{
      lost_sanity: max(lost_sanity - @rest_sanity_recovery, 0),
      rest_timer: NaiveDateTime.utc_now(),
      cigs: cigs - rest_cost
    }

    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end
end
