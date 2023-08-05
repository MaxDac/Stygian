defmodule StygianWeb.ChatLive.MapLive do
  use StygianWeb, :live_view

  alias Stygian.Maps

  @impl true
  def mount(%{"map_id" => map_id}, _session, socket) do
    map = get_map(map_id)

    {:ok,
      socket
      |> assign(:map, map)
    }
  end

  defp get_map(map_id) do
    Maps.get_map_with_children(map_id)
  end
end
