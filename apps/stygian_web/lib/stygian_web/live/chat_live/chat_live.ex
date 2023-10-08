defmodule StygianWeb.ChatLive.ChatLive do
  @moduledoc """
  This live view will render both the chat screen and the chat input.

  There was an issue with the reset of the textarea, where, when the chat input was sent, the textarea could not reset
  as the component didn't need the update.

  To force the update, the component will send a message to the genserver, that is the same of this live view that
  renders it, in order for this live view to update the id of the textarea, forcing the update of the component.

  This workaround prevented using JavaScript to update the state from the client.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Maps
  alias StygianWeb.ChatLive.ChatControlLive
  alias StygianWeb.ChatLive.ChatDiceThrowerLive
  alias StygianWeb.ChatLive.ChatHelpers
  alias StygianWeb.ChatLive.ObjectUsageLive
  alias StygianWeb.Presence

  import StygianWeb.ChatLive.ChatEntryLive

  @event_name_chat_created "chat_created"

  @doc """
  Returns the chat created event.
  """
  def get_event_chat_created, do: @event_name_chat_created

  @impl true
  def mount(%{"map_id" => map_id}, _session, socket) do
    {:ok,
     socket
     |> assign_map(map_id)
     |> assign(:show_dice_thrower, false)
     |> assign(:show_object_usage, false)
     |> update_presence()
     |> assign_chat_entries(Maps.list_map_chats(map_id))
     |> ChatHelpers.subscribe_to_chat_events(map_id)
     |> assign_textarea_id()
     |> assign_dice_button_id()
     |> assign_use_object_id()
     |> check_private_room_allowance()}
  end

  @impl true
  def handle_info(%{event: @event_name_chat_created, payload: chat_entry}, socket) do
    {:noreply,
     socket
     |> assign_new_chat_entry(chat_entry)}
  end

  @impl true
  def handle_info({:chat_input_sent, _}, socket) do
    send_update(ChatControlLive, id: socket.assigns.map.id, textarea_id: new_textarea_id())
    {:noreply, socket}
  end

  @impl true
  def handle_info(:close_modal, socket) do
    {:noreply,
     socket
     |> assign(:show_dice_thrower, false)
     |> assign(:show_object_usage, false)
     |> assign_dice_button_id()
     |> assign_use_object_id()}
  end

  # This is called when the dice thrower modal is closed
  @impl true
  def handle_info({:chat, _}, socket) do
    send_update(ChatControlLive, id: socket.assigns.map.id)

    {:noreply,
     socket
     |> assign(:show_dice_thrower, false)
     |> assign(:show_object_usage, false)
     |> assign_dice_button_id()}
  end

  # Dice button clicked
  @impl true
  def handle_event("open_dices", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_dice_thrower, true)}
  end

  # Object button clicked
  @impl true
  def handle_event("open_objects", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_object_usage, true)}
  end

  @impl true
  def handle_params(%{"map_id" => map_id}, uri, socket) do
    {:noreply,
     socket
     |> assign_map(map_id)
    # Updates the random number passed down with the component id to the live component to force it to update.
     |> assign_dice_button_id()
     |> assign_use_object_id()
     |> assign(:show_dice_thrower, false)
     |> assign(:show_object_usage, false)}
  end

  defp assign_new_chat_entry(%{assigns: %{chat_entries: chat_entries}} = socket, chat_entry) do
    assign_chat_entries(socket, chat_entries ++ [chat_entry])
  end

  defp assign_chat_entries(socket, chats) do
    assign(socket, :chat_entries, chats)
  end

  defp assign_map(socket, map_id) do
    map = Maps.get_map!(map_id)
    assign(socket, map: map)
  end

  defp assign_textarea_id(socket) do
    assign(socket, :textarea_id, new_textarea_id())
  end

  defp assign_dice_button_id(socket) do
    assign(socket, :dice_button_id, new_dice_button_id())
  end

  defp assign_use_object_id(socket) do
    assign(socket, :use_object_id, new_use_object_id())
  end

  defp check_private_room_allowance(%{assigns: %{current_user: %{admin: true}}} = socket),
    do: socket

  defp check_private_room_allowance(
         %{
           assigns: %{
             map: %{id: map_id, private: true},
             current_character: %{id: current_character_id}
           }
         } = socket
       ) do
    if Maps.is_character_allowed?(map_id, current_character_id) do
      socket
    else
      socket
      |> put_flash(:error, "Non puoi accedere a questa stanza")
      |> push_navigate(to: ~p"/")
    end
  end

  defp check_private_room_allowance(socket), do: socket

  defp new_textarea_id, do: "textarea-id-#{:rand.uniform(10)}"

  defp new_dice_button_id, do: "dice-button-id-#{:rand.uniform(10)}"

  defp new_use_object_id, do: "use-object-button-id-#{:rand.uniform(10)}"

  defp update_presence(
         %{
           assigns: %{
             current_user: current_user,
             current_character: current_character,
             map: map
           }
         } = socket
       ) do
    if connected?(socket) do
      Presence.track_user(self(), current_user, current_character, map, true)
    end

    socket
  end
end
