defmodule StygianWeb.ChatLive.MapLive do
  use StygianWeb, :live_view

  alias Stygian.Maps
  alias StygianWeb.Presence

  @impl true
  def mount(%{"map_id" => map_id}, _session, socket) do
    map = get_map(map_id)

    {:ok,
     socket
     |> assign(:map, map)
     |> update_presence()}

  end

  defp get_map(map_id) do
    Maps.get_map_with_children(map_id)
  end

  defp update_presence(%{assigns: %{
    current_user: current_user, 
    current_character: current_character,
    map: map
  }} = socket) do
    if connected?(socket) do
      Presence.track_user(self(), current_user, current_character, map)
    end

    socket
  end
end
