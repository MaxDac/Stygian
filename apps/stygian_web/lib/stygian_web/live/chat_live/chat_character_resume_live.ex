defmodule StygianWeb.ChatLive.ChatCharacterResumeLive do
  @moduledoc """
  This component will show the character resume.
  If the current user is an admin, it will allow them to edit the character status.
  """

  use StygianWeb, :live_component

  alias Stygian.Characters

  @impl true
  def update(%{character_id: character_id} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_character(character_id)}
  end

  defp assign_character(socket, character_id) do
    character = Characters.get_character_slim(character_id)
    assign(socket, :character, character)
  end
end
