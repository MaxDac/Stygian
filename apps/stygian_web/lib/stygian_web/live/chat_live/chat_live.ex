defmodule StygianWeb.ChatLive.ChatLive do
  use StygianWeb, :container_live_view

  alias StygianWeb.ChatLive.ChatControlLive
  alias Stygian.Maps

  @impl true
  def mount(%{"map_id" => map_id}, _session, socket) do
    {:ok,
      socket
      |> assign_map(map_id)
    }
  end

  defp assign_map(socket, map_id) do
    map = Maps.get_map!(map_id)
    assign(socket, map: map)
  end
end
