defmodule StygianWeb.ChatLive.ChatDiceThrowerLive do
  @moduledoc """
  LiveView for the dice thrower.
  """

  use StygianWeb, :live_component

  alias StygianWeb.Presence

  embed_templates "dice_thrower_templates/*"

  alias Stygian.Characters.DiceThrower
  alias Stygian.Combat
  alias Stygian.Dices.CharacterActionForm

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_mode()
     |> assign_current_character()
     |> assign_form()
     |> assign_combat_actions()
     |> assign_character_form()}
  end

  @impl true
  def handle_event("submit", %{"dice_thrower" => params}, socket) when is_map(params) do
    changeset = DiceThrower.changeset(%DiceThrower{}, params)

    if changeset.valid? do
      insert_dice_chat(socket, params)
    else
      {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  @impl true
  def handle_event("action_submit", %{"character_action_form" => params}, socket) do
    changeset = CharacterActionForm.changeset(%CharacterActionForm{}, params)

    if changeset.valid? do
      insert_character_action_chat(socket, changeset.changes)
    else
      {:noreply, assign(socket, character_form: to_form(changeset))}
    end
  end

  @impl true
  def handle_event("toggle_window", _, socket) do
    {:noreply,
     socket
     |> assign_online_characters()
     |> toggle_mode()}
  end

  defp assign_form(socket) do
    form =
      %DiceThrower{
        attribute_id: 1,
        skill_id: 1,
        modifier: 0,
        difficulty: 20
      }
      |> DiceThrower.changeset()
      |> to_form()

    assign(socket, :form, form)
  end

  defp assign_character_form(socket, attrs \\ %{}) do
    form =
      %CharacterActionForm{}
      |> CharacterActionForm.changeset(attrs)
      |> to_form()

    assign(socket, :character_form, form)
  end

  defp to_options(list) do
    Enum.map(list, fn %{id: id, skill: %{name: name}} -> {name, id} end)
  end

  defp range_as_options(range) do
    Enum.map(range, fn value -> {value, value} end)
  end

  defp insert_dice_chat(socket, params) do
    params =
      params
      |> Map.new(fn {key, value} -> {String.to_atom(key), String.to_integer(value)} end)

    send(self(), {:chat_dices, params})

    {:noreply, socket}
  end

  defp insert_character_action_chat(socket, %{
         attacker_character_id: attacker_character_id,
         defending_character_id: defending_character_id,
         combat_action_id: combat_action_id
       }) do
    send(
      self(),
      {:chat_character_action,
       %{
         action_id: combat_action_id,
         attacker_id: attacker_character_id,
         defender_id: defending_character_id
       }}
    )

    {:noreply, socket}
  end

  defp assign_mode(socket) do
    assign(socket, :mode, :dices)
  end

  defp assign_current_character(
         %{assigns: %{current_character: %{id: current_character_id}}} = socket
       ) do
    assign(socket, :current_character_id, current_character_id)
  end

  defp assign_online_characters(
         %{
           assigns: %{
             map: %{name: map_name},
             current_character: %{id: current_character_id}
           }
         } = socket
       ) do
    characters =
      Presence.list_users()
      |> Map.get(map_name, [])
      |> Enum.map(& &1.character)
      |> Enum.filter(&(&1 != nil && &1.id != current_character_id))

    assign(socket, :online_characters, characters)
  end

  defp assign_combat_actions(socket) do
    actions = Combat.list_combat_actions()
    assign(socket, :combat_actions, actions)
  end

  defp toggle_mode(%{assigns: %{mode: :dices}} = socket) do
    assign(socket, :mode, :character)
  end

  defp toggle_mode(socket) do
    assign(socket, :mode, :dices)
  end

  defp get_toggle_mode_label(mode)
  defp get_toggle_mode_label(:dices), do: "Personaggio"
  defp get_toggle_mode_label(:character), do: "Dadi"
end
