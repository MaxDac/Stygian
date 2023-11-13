defmodule StygianWeb.WeaponLive.WeaponAssignmentDetail do
  @moduledoc """
  This component allows to assign or remove a weapon from a character.
  """
  
  use StygianWeb, :live_component

  alias Stygian.Weapons

  @impl true
  def update(assigns, socket) do
    {:ok, 
     socket
     |> assign(assigns)
     |> assign_character_weapons(assigns.character_id)}
  end

  defp assign_character_weapons(socket, character_id \\ nil)

  defp assign_character_weapons(socket, nil), do: socket

  defp assign_character_weapons(socket, character_id) do
    stream(socket, :character_weapons, Weapons.list_character_weapons(character_id))
  end
end
