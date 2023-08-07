defmodule StygianWeb.ChatLive.ChatLive do
  use StygianWeb, :container_live_view

  alias StygianWeb.ChatLive.ChatHelpers
  alias StygianWeb.ChatLive.ChatControlLive
  alias Stygian.Maps

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
      |> assign_chat_entries(Maps.list_map_chats(map_id))
      |> ChatHelpers.subscribe_to_chat_events(map_id)
    }
  end

  @impl true
  def handle_info(%{event: @event_name_chat_created, payload: chat_entry}, socket) do
    {:noreply, 
      socket
      |> assign_new_chat_entry(chat_entry)
    }
  end

  defp assign_new_chat_entry(%{assigns: %{chat_entries: chat_entries}} = socket, chat_entry) do
    socket
    |> assign_chat_entries([chat_entry | chat_entries])
  end

  defp assign_chat_entries(socket, chats) do
    assign(socket, :chat_entries, chats)
  end

  defp assign_map(socket, map_id) do
    map = Maps.get_map!(map_id)
    assign(socket, map: map)
  end
end
