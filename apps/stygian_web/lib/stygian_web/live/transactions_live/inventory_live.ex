defmodule StygianWeb.TransactionsLive.InventoryLive do
  @moduledoc """
  This page exposes the inventory of a character.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Objects

  @impl true
  def mount(_, _, %{assigns: %{current_character: %{id: character_id}}} = socket) do
    {:ok,
     socket
     |> assign_inventory_character(character_id)
     |> assign_character_inventory()}
  end

  @impl true
  def handle_params(params, _uri, %{assigns: %{live_action: :use}} = socket) do
    IO.inspect(params, label: "use")
    {:noreply, socket}
  end

  @impl true
  def handle_params(%{"id" => character_object_id}, _uri, %{assigns: %{live_action: :give}} = socket) do
    character_object = Objects.get_character_object!(character_object_id)

    {:noreply,
     socket
     |> assign(:character_object, character_object)}
  end

  @impl true
  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    character_object = Objects.get_character_object!(id)
    {:ok, _} = Objects.delete_character_object(character_object)

    {:noreply,
     socket
     |> assign_character_inventory()}
  end

  defp assign_inventory_character(socket, character_id) do
    assign(socket, :inventory_character_id, character_id)
  end

  defp assign_character_inventory(%{assigns: %{inventory_character_id: character_id}} = socket) do
    assign_async(socket, :inventory, fn -> 
      {:ok, %{
        inventory: Objects.list_character_objects(character_id)
      }} 
    end)
  end
end
