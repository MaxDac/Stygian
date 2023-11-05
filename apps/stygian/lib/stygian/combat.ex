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

  alias Stygian.Combat.ChatAction

  @doc """
  Returns the list of chat_actions.

  ## Examples

      iex> list_chat_actions()
      [%ChatAction{}, ...]

  """
  def list_chat_actions do
    Repo.all(ChatAction)
  end

  @doc """
  Gets a single chat_action.

  Raises `Ecto.NoResultsError` if the Chat action does not exist.

  ## Examples

      iex> get_chat_action!(123)
      %ChatAction{}

      iex> get_chat_action!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat_action!(id), do: Repo.get!(ChatAction, id)

  @doc """
  Gets a single chat_action.

  Returns nil if the chat_action does not exist.

  ## Examples

      iex> get_chat_action(123)
      %ChatAction{}

      iex> get_chat_action(456)
      nil

  """
  def get_chat_action(id), do: Repo.get(ChatAction, id)

  @doc """
  Gets the chat action with the foreign keys preloaded.
  """
  @spec get_chat_action_preloaded(non_neg_integer()) :: ChatAction.t()
  def get_chat_action_preloaded(id) do
    ChatAction
    |> from()
    |> where([ca], ca.id == ^id)
    |> preload(:attacker)
    |> preload(:defender)
    |> preload(action: :weapon_type)
    |> preload(action: :attack_attribute)
    |> preload(action: :attack_skill)
    |> preload(action: :defence_attribute)
    |> preload(action: :defence_skill)
    |> Repo.one()
  end

  @doc """
  Creates a chat_action.

  ## Examples

      iex> create_chat_action(%{field: value})
      {:ok, %ChatAction{}}

      iex> create_chat_action(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat_action(attrs \\ %{}) do
    %ChatAction{}
    |> ChatAction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat_action.

  ## Examples

      iex> update_chat_action(chat_action, %{field: new_value})
      {:ok, %ChatAction{}}

      iex> update_chat_action(chat_action, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat_action(%ChatAction{} = chat_action, attrs) do
    chat_action
    |> ChatAction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chat_action.

  ## Examples

      iex> delete_chat_action(chat_action)
      {:ok, %ChatAction{}}

      iex> delete_chat_action(chat_action)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat_action(%ChatAction{} = chat_action) do
    Repo.delete(chat_action)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat_action changes.

  ## Examples

      iex> change_chat_action(chat_action)
      %Ecto.Changeset{data: %ChatAction{}}

  """
  def change_chat_action(%ChatAction{} = chat_action, attrs \\ %{}) do
    ChatAction.changeset(chat_action, attrs)
  end

  alias Stygian.Characters
  alias Stygian.Combat.ChatAction
  alias Stygian.Dices
  alias Stygian.Maps.Chat

  @doc """
  Creates a chat action and a chat entry to accept it.
  """
  @spec create_action_for_chat(request :: ChatAction.t(), map_id :: integer()) ::
          {:ok,
           %{
             chat_action: ChatAction.t(),
             chat: Chat.t()
           }}
          | {:error, any()}
          | {:error, String.t()}
  def create_action_for_chat(request, map_id) do
    with :ok <- check_action(request) do
      chat_action_changeset = ChatAction.changeset(%ChatAction{}, request)

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:chat_action, chat_action_changeset)
      |> Ecto.Multi.insert(:chat, &create_chat_action_chat_entry(&1, map_id))
      |> Repo.transaction()
    end
  end

  defp check_action(%{
         action_id: action_id,
         attacker_id: attacker_id
       }) do
    %{attack_skill_id: attacker_skill_id, minimum_skill_value: minimum_skill_value} =
      get_action!(action_id)

    %{value: value} = Characters.get_character_skill(attacker_id, attacker_skill_id)

    if value < minimum_skill_value do
      {:error, "Il personaggio non ha un livello sufficiente di abilità per tentare l'azione"}
    else
      :ok
    end
  end

  defp create_chat_action_chat_entry(
         %{
           chat_action: %{
             id: chat_action_id,
             attacker_id: attacker_id,
             defender_id: defender_id
           }
         },
         map_id
       ) do
    %{name: attacker_name} = Characters.get_character!(attacker_id)

    Chat.chat_action_changeset(%Chat{}, %{
      character_id: defender_id,
      map_id: map_id,
      chat_action_id: chat_action_id,
      type: :confirm,
      text: "Stai ricevendo un attacco da #{attacker_name}. Lo confermi?"
    })
  end

  @doc """
  Invoked when the user cancels the chat action. This will simply invalidate the action.
  """
  @spec cancel_chat_action(chat_action_id :: non_neg_integer()) ::
          {:ok,
           %{
             deleted_chat: Chat.t(),
             chat_action: ChatAction.t(),
             added_chat: Chat.t()
           }}
          | {:error, Ecto.Changeset.t()}
  def cancel_chat_action(chat_action_id) do
    chat_action = get_chat_action_preloaded(chat_action_id)

    Ecto.Multi.new()
    |> update_chat_action_status(chat_action, %{
      resolved: true,
      accepted: false
    })
    |> remove_chat(chat_action_id)
    |> add_cancel_action_chat(chat_action)
    |> Repo.transaction()
  end

  @doc """
  Invoked when the user confirms the chat action. This will execute the action materially, applying the effects.
  """
  @spec confirm_chat_action(chat_action_id :: non_neg_integer(), dice_thrower :: function()) ::
          {:ok,
           %{
             deleted_chat: Chat.t(),
             character: Characters.Character.t(),
             added_chat: Chat.t()
           }}
          | {:error, any()}
  def confirm_chat_action(chat_action_id, dice_thrower) do
    chat_action = get_chat_action_preloaded(chat_action_id)
    %{map_id: map_id} = get_chat_entry_by_chat_action_id(chat_action_id)
    {attacker_result, defender_result} = get_dice_results(chat_action, dice_thrower)

    succeeded? = attacker_result >= defender_result

    health_damage =
      if chat_action.action.does_damage,
        do: max(attacker_result - defender_result, 0),
        else: 0

    Ecto.Multi.new()
    |> update_chat_action_status(chat_action, %{
      resolved: true,
      accepted: true
    })
    |> remove_chat(chat_action_id)
    |> update_defender_health(chat_action.defender_id, health_damage)
    |> add_result_chat(chat_action, map_id, health_damage, succeeded?)
    |> Repo.transaction()
  end

  defp update_chat_action_status(multi, chat_action, attrs) do
    cancel_chat_action_changeset = ChatAction.changeset(chat_action, attrs)
    Ecto.Multi.update(multi, :chat_action, cancel_chat_action_changeset)
  end

  defp get_dice_results(
         %{
           attacker_id: attacker_id,
           defender_id: defender_id,
           action: %{
             attack_attribute_id: attack_attribute_id,
             attack_skill_id: attack_skill_id,
             defence_attribute_id: defence_attribute_id,
             defence_skill_id: defence_skill_id
           }
         } = _chat_action,
         dice_thrower
       ) do
    {
      %{value: attack_attribute_value},
      %{value: attack_skill_value},
      %{value: defence_attribute_value},
      %{value: defence_skill_value}
    } = {
      Characters.get_character_skill(attacker_id, attack_attribute_id),
      Characters.get_character_skill(attacker_id, attack_skill_id),
      Characters.get_character_skill(defender_id, defence_attribute_id),
      Characters.get_character_skill(defender_id, defence_skill_id)
    }

    dice_faces = Dices.get_dice_faces()
    attacker_dice = dice_thrower.(dice_faces)
    defender_dice = dice_thrower.(dice_faces)

    {
      attack_attribute_value + attack_skill_value + attacker_dice,
      defence_attribute_value + defence_skill_value + defender_dice
    }
  end

  defp update_defender_health(multi, defender_character_id, health_lost)
  defp update_defender_health(multi, _, 0), do: multi

  defp update_defender_health(multi, defender_character_id, health_lost) do
    character = Characters.get_character!(defender_character_id)
    new_lost_health = character.lost_health + health_lost

    character_changeset =
      Characters.change_character_status(character, %{lost_health: new_lost_health})

    Ecto.Multi.update(multi, :character, character_changeset)
  end

  defp add_result_chat(
         multi,
         %{
           attacker_id: attacker_id,
           defender_id: defender_id,
           action: %{
             weapon_type: %{
               name: weapon_type_name
             }
           }
         },
         map_id,
         health_lost,
         succeeded?
       ) do
    defender_character = Characters.get_character!(defender_id)

    chat_text_description = get_chat_text_description(defender_character.name, weapon_type_name)
    chat_text_outcome = get_chat_text_outcome(health_lost, succeeded?)
    chat_text = "#{chat_text_description} #{chat_text_outcome}"

    new_chat_attrs = %{
      type: :action_result,
      text: chat_text,
      character_id: attacker_id,
      map_id: map_id
    }

    Ecto.Multi.insert(multi, :added_chat, Chat.changeset(%Chat{}, new_chat_attrs))
  end

  defp get_chat_text_outcome(_, false), do: "fallendo."
  defp get_chat_text_outcome(0, _), do: "senza infliggere danni."

  defp get_chat_text_outcome(health_lost, _),
    do: "infliggendo #{health_lost} punti di salute di danno."

  defp get_chat_text_description(defender_character_name, weapon_type_name),
    do: "Attacca #{defender_character_name} con #{weapon_type_name},"

  defp add_cancel_action_chat(multi, %{
         id: chat_action_id,
         attacker_id: attacker_id,
         defender_id: defender_id,
         action: %{
           weapon_type: %{
             name: weapon_type_name
           }
         }
       }) do
    chat_entry = get_chat_entry_by_chat_action_id(chat_action_id)
    attacker_character = Characters.get_character!(attacker_id)

    new_chat_attrs = %{
      type: :off,
      text: "L'attacco di #{attacker_character.name} con #{weapon_type_name}, è stato rifiutato.",
      character_id: defender_id,
      map_id: chat_entry.map_id
    }

    Ecto.Multi.insert(multi, :added_chat, Chat.changeset(%Chat{}, new_chat_attrs))
  end

  @spec remove_chat(multi :: Ecto.Multi.t(), chat_action_id :: non_neg_integer()) ::
          Ecto.Multi.t()
  defp remove_chat(multi, chat_action_id) do
    case get_chat_entry_by_chat_action_id(chat_action_id) do
      nil ->
        multi

      chat_entry ->
        Ecto.Multi.delete(multi, :deleted_chat, chat_entry)
    end
  end

  defp get_chat_entry_by_chat_action_id(chat_action_id) do
    Repo.get_by(Chat, chat_action_id: chat_action_id)
  end
end
