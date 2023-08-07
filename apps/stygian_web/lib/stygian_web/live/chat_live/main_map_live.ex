defmodule StygianWeb.ChatLive.MainMapLive do
  use StygianWeb, :live_view

  alias Stygian.Maps
  alias StygianWeb.Presence

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:parent_maps, get_parent_maps())
     |> update_presence()}
  end

  defp get_parent_maps do
    Maps.list_parent_maps()
  end

  defp update_presence(%{assigns: %{
    current_user: current_user, 
    current_character: current_character
  }} = socket) do
    if connected?(socket) do
      Presence.track_user(self(), current_user, current_character)
    end

    socket
  end
end
