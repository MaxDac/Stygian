defmodule StygianWeb.ChatLive.ChatHelpers do
  @moduledoc """
  Contains helpers to manage broadcasting the chat messages.
  """

  alias Phoenix.LiveView.Socket

  alias Stygian.Maps.Chat
  alias StygianWeb.ChatLive.ChatLive
  alias StygianWeb.Endpoint

  import Phoenix.LiveView

  @doc """
  Broadcasts the chat entry insertion to the map channel.
  """
  @spec handle_chat_created(socket :: Socket.t(), chat :: Chat.t()) :: Socket.t()
  def handle_chat_created(%{assigns: %{map: %{id: map_id}}} = socket, chat_entry) do
    Endpoint.broadcast(get_broatcast_topic(map_id), ChatLive.get_event_chat_created(), chat_entry)
    socket
  end

  @doc """
  Broadcasts the chat entry deletion to the map channel.
  """
  @spec handle_chat_deleted(socket :: Socket.t(), chat :: Chat.t()) :: Socket.t()
  def handle_chat_deleted(%{assigns: %{map: %{id: map_id}}} = socket, chat_entry) do
    Endpoint.broadcast(get_broatcast_topic(map_id), ChatLive.get_event_chat_deleted(), chat_entry)
    socket
  end

  @doc """
  Subscribes the component to the map channel to receive chat messages.

  The subscriber must also implement the `handle_info/2` callback to handle the messages being sent.
  """
  @spec subscribe_to_chat_events(Socket.t(), integer()) :: Socket.t()
  def subscribe_to_chat_events(socket, map_id) do
    if connected?(socket) do
      Endpoint.subscribe(get_broatcast_topic(map_id))
    end

    socket
  end

  defp get_broatcast_topic(map_id) do
    "map:#{map_id}:chat"
  end
end
