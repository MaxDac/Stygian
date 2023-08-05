defmodule StygianWeb.ChatLive.ChatLive do
  use StygianWeb, :container_live_view

  alias Stygian.Maps

  @impl true
  def mount(%{"map_id" => map_id}, _session, socket) do
    {:ok,
      socket
      |> assign(:map, get_map(map_id))
    }
  end

  defp get_map(map_id) do
    Maps.get_map!(map_id)
  end
end
