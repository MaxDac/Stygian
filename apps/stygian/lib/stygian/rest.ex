defmodule Stygian.Rest do
  @moduledoc """
  The Rest context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset

  alias Stygian.Repo

  alias Stygian.Characters.Character
  alias Stygian.Rest.RestAction

  @rest_limit_hours 24
  @rest_health_recovery 0
  @rest_sanity_recovery 5
  @rest_cost 5

  @complex_rest_cost 20
  @max_allowed_slots 5

  def get_rest_cost, do: @rest_cost
  def get_complex_rest_cost, do: @complex_rest_cost
  def get_max_allowed_slots, do: @max_allowed_slots

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
  @spec rest_character(character :: Character.t()) ::
          {:ok, Character.t()} | {:error, String.t()} | {:error, Changeset.t()}
  def rest_character(character) do
    with {:ok, character} <- check_character_last_rest(character),
         {:ok, character} <- check_character_cigs(character, @rest_cost) do
      attrs =
        character
        |> get_empty_attrs()
        |> apply_rest_cost(@rest_cost)
        |> apply_simple_rest_effect()

      character
      |> Character.change_rest_stats_changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Perform the resting of the character, with a custom cost and the possibility of performing actions. 
  """
  @spec rest_character_complex(character :: Character.t(), actions :: list(RestAction.t())) ::
          {:ok, Character.t()} | {:error, String.t()} | {:error, Changeset.t()}
  def rest_character_complex(character, actions) do
    with {:ok, character} <- check_character_last_rest(character),
         {:ok, character} <- check_character_cigs(character, @complex_rest_cost),
         {:ok, actions} <- check_slots(actions) do
      attrs =
        character
        |> get_empty_attrs()
        |> apply_rest_cost(@complex_rest_cost)
        |> apply_simple_rest_effect()
        |> apply_actions(actions)

      character
      |> Character.change_rest_stats_changeset(attrs)
      |> Repo.update()
    end
  end

  defp check_character_last_rest(%{rest_timer: rest_timer} = character) do
    case rest_timer do
      nil ->
        {:ok, character}

      rest_timer ->
        limit =
          NaiveDateTime.utc_now()
          |> NaiveDateTime.add(@rest_limit_hours * -1, :hour)

        if NaiveDateTime.compare(rest_timer, limit) == :lt do
          {:ok, character}
        else
          {:error, "Non puoi ancora far riposare il personaggio."}
        end
    end
  end

  defp check_character_cigs(%{cigs: cigs} = character, cost) when cigs >= cost,
    do: {:ok, character}

  defp check_character_cigs(_, _),
    do: {:error, "Non hai abbastanza sigarette per poter pagare l'albergo."}

  defp check_slots(actions) do
    slots =
      actions
      |> Enum.map(& &1.slots)
      |> Enum.sum()

    if slots > @max_allowed_slots do
      {:error, "Non puoi aggiungere questa azione, non hai sufficienti slot a disposizione."}
    else
      {:ok, actions}
    end
  end

  defp get_empty_attrs(
         %{
           cigs: cigs,
           lost_health: lost_health,
           lost_sanity: lost_sanity,
           research_points: research_points
         } = _character
       ),
       do: %{
         cigs: cigs,
         lost_health: lost_health,
         lost_sanity: lost_sanity,
         research_points: research_points,
         rest_timer: NaiveDateTime.utc_now()
       }

  defp apply_rest_cost(attrs, rest_cost) do
    attrs
    |> Map.update!(:cigs, &(&1 - rest_cost))
  end

  defp apply_simple_rest_effect(attrs) do
    attrs
    |> Map.update!(:lost_health, &max(&1 - @rest_health_recovery, 0))
    |> Map.update!(:lost_sanity, &max(&1 - @rest_sanity_recovery, 0))
  end

  defp apply_actions(attrs, actions) do
    Enum.reduce(actions, attrs, fn action, attrs -> apply_action(attrs, action) end)
  end

  defp apply_action(attrs, action)

  defp apply_action(attrs, %{research_points: research_points}) when research_points > 0 do
    Map.update!(attrs, :research_points, &(&1 + research_points))
  end

  defp apply_action(attrs, %{health: health}) when health > 0 do
    Map.update!(attrs, :lost_health, &max(&1 - health, 0))
  end

  defp apply_action(attrs, %{sanity: sanity}) when sanity > 0 do
    Map.update!(attrs, :lost_sanity, &max(&1 - sanity, 0))
  end

  defp apply_action(attrs, _), do: attrs
end
