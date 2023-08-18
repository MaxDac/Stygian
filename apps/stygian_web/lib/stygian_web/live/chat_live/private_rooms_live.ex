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

    <div class="flex flex-col space-y-3">
      <div :for={map <- @private_maps} class="text-center w-full flex flex-col space-y-0">
        <span class="font-report text-2xl"><%= map.name %></span>
        <.link
          :if={map.status == :occupied && has_access(@current_character, map)}
          navigate={~p"/chat/#{map.id}"}
        >
          <span class="font-typewriter text-sm text-zinc-300">Accedi</span>
        </.link>
        <span
          :if={map.status == :occupied && not has_access(@current_character, map)}
          class="font-typewriter text-sm text-rose-700"
        >
          Occupata
        </span>
        <.link :if={map.status == :free} navigate={~p"/map/private/book/#{map.id}"}>
          <span class="font-typewriter text-sm text-zinc-300">Libera - Prenota</span>
        </.link>
        <.link :if={@current_user.admin} navigate={~p"/chat/#{map.id}"}>
          <span class="font-typewriter text-sm text-rose-700">Accedi</span>
        </.link>
      </div>
    </div>
    """
  end

  defp assign_private_maps(socket) do
    private_maps = Maps.list_private_rooms()
    assign(socket, :private_maps, private_maps)
  end

  defp has_access(current_character, %{hosts: hosts}) do
    Enum.any?(hosts, fn %{character_id: character_id} -> character_id == current_character.id end)
  end
end
