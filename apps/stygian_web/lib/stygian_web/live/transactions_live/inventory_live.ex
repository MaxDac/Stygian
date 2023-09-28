defmodule StygianWeb.TransactionsLive.InventoryLive do
  @moduledoc """
  This page exposes the inventory of a character.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Objects

  @impl true
  def mount(params, session, %{assigns: %{current_character: %{id: character_id}}} = socket) do
    {:ok,
     socket
     |> assign_character_inventory(character_id)}
  end

  defp assign_character_inventory(socket, character_id) do
    assign_async(socket, :inventory, fn -> 
      {:ok, %{
        inventory: Objects.list_character_objects(character_id)
      }} 
    end)
  end
end
