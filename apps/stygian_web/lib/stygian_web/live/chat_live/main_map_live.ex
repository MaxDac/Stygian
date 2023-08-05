defmodule StygianWeb.ChatLive.MainMapLive do
  use StygianWeb, :live_view

  alias Stygian.Maps

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(:parent_maps, get_parent_maps())
    }
  end

  defp get_parent_maps do
    Maps.list_parent_maps() |> IO.inspect(label: "map")
  end
end
