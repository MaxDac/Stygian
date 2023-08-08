defmodule StygianWeb.ChatLive.OnlineLive do
  @moduledoc """
  Lists the online users.
  """

  use StygianWeb, :container_live_view

  alias StygianWeb.Presence
  alias StygianWeb.Endpoint

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(Presence.get_online_topic())
    end

    {:ok,
     socket
     |> assign_users_list(Presence.list_users())}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: payload}, socket) do
    {:noreply,
     socket
     |> assign_users_list(payload)}
  end

  defp get_map_link(online, location) do
    case online[location] do
      [%{map: %{id: map_id, is_chat: true}}] when not is_nil(map_id) -> ~p"/chat/#{map_id}"
      [%{map: %{id: map_id}}] when not is_nil(map_id) -> ~p"/map/#{map_id}"
      _ -> ~p"/"
    end
  end

  defp assign_users_list(socket, users_list) do
    socket
    |> assign(:online, users_list)
  end
end
