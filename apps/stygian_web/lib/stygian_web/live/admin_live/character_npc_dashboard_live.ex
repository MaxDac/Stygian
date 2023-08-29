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

    <div :for={npc <- @npcs}>
      <%= npc.name %>
    </div>

    <div class="w-full text-center">
      <.link navigate={~p"/admin/npc/create"} class="font-typewriter">
        Crea nuovo PNG
      </.link>
    </div>
    """
  end

  defp assign_npcs(socket) do
    npcs = Characters.list_npcs()
    assign(socket, :npcs, npcs)
  end
end
