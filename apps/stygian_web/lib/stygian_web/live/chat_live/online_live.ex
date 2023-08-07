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
      |> IO.inspect(label: "subscribing")
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

  defp assign_users_list(socket, users_list) do
    IO.inspect users_list, label: "Users list"
    socket
    |> assign(:online, users_list)
  end
end
