defmodule StygianWeb.ChatLive.PrivateRoomsLive do
  @moduledoc """
  Manages the private rooms.
  """
  
  use StygianWeb, :container_live_view

  alias Stygian.Maps

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
     socket
     |> assign_private_maps()}
  end
  
  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Locazioni private.</.h1>

    <div :for={map <- @private_maps}>
      <%= map.name %> <%= map.status %>
    </div>
    """
  end

  defp assign_private_maps(socket) do
    private_maps = Maps.list_private_rooms()
    assign(socket, :private_maps, private_maps)
  end
end
