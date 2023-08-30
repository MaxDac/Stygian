defmodule StygianWeb.AdminLive.CharacterNpcDashboardLive do
  @moduledoc """
  This is the admin dashboard for the NPCs. 
  """

  use StygianWeb, :container_live_view

  alias Stygian.Characters

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_npcs()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>PNG</.h1>

    <div class="w-full flex justify-center not-format p-2">
      <img src="/images/divider.webp" alt="divider" class="max-h-[30px] w-auto not-format" />
    </div>

    <div class="w-full text-center">
      <.link 
        navigate={~p"/admin/npc/create"} 
        class="font-typewriter"
      >
        Crea nuovo PNG
      </.link>
    </div>

    <div class="w-full flex justify-center not-format p-2">
      <img src="/images/divider.webp" alt="divider" class="max-h-[30px] w-auto not-format -scale-y-100" />
    </div>

    <div :for={%{id: npc_id, name: npc_name} <- @npcs} class="w-full text-center py-2 font-typewriter">
      <.link navigate={~p"/character/sheet/#{npc_id}"}>
        <%= npc_name %>
      </.link>

      <span>
        ( <.link navigate={~p"/admin/redirect/#{npc_id}"}>Seleziona</.link> )
      </span>
    </div>
    """
  end

  defp assign_npcs(socket) do
    npcs = Characters.list_npcs()
    assign(socket, :npcs, npcs)
  end
end
