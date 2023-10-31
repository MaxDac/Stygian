defmodule StygianWeb.ChatLive.ChatDiceThrowerLive do
  @moduledoc """
  LiveView for the dice thrower.
  """

  use StygianWeb, :live_component

  alias StygianWeb.Presence

  embed_templates "dice_thrower_templates/*"

  alias Stygian.Characters.DiceThrower

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_mode()
     |> assign_form()}
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

  defp assign_mode(socket) do
    assign(socket, :mode, :dices)
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

  defp assign_online_characters(socket) do
    characters = Presence.list_users() |> IO.inspect(label: "characters")
    assign(socket, :online_characters, characters)
  end
end
